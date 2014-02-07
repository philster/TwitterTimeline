//
//  TimelineVC.m
//  TwitterTimeline
//
//  Created by Phil Wee on 2/2/14.
//  Copyright (c) 2014 Philster. All rights reserved.
//

#import "TimelineVC.h"
#import "ComposeVC.h"
#import "TweetCell.h"
#import "TweetVC.h"
#import "UIImageView+AFNetworking.h"

@interface TimelineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;

- (void)onSignOutButton;
- (void)reload;

@end

@implementation TimelineVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Home";
        
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Style with Twitter colors
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
    
    // Create Sign Out and New buttons
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onCompose)];
    
    // Load custom UITableViewCell from nib
    UINib *customNib = [UINib nibWithNibName:@"TweetCell" bundle:nil];
    [self.tableView registerNib:customNib forCellReuseIdentifier:@"MyTweetCell"];

    // Enable pull to refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyTweetCell";
    TweetCell *cell = (TweetCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    Tweet *tweet = self.tweets[indexPath.row];
    cell.textLabel.text = tweet.text;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    cell.nameLabel.text = tweet.name;
    cell.screenNameLabel.text = tweet.screen_name;
    cell.createdAtLabel.text = tweet.created_at_veryshort;
    if (tweet.retweeted_by) {
        cell.retweetedByLabel.text = [NSString stringWithFormat:@"%@ retweeted", tweet.retweeted_by];
    } else {
        cell.retweetedByLabel.hidden = YES;
        cell.heightConstraint.constant = 0;
    }

    NSURL *url = [NSURL URLWithString:tweet.profile_image_url];
    [cell.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    [cell.retweetButton setBackgroundImage:[UIImage imageNamed:@"icn_retweet_off"] forState:UIControlStateNormal];
    [cell.retweetButton setBackgroundImage:[UIImage imageNamed:@"icn_retweet_on"] forState:UIControlStateSelected];
    [cell.retweetButton setSelected:tweet.retweeted];
    
    [cell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"icn_favorite_off"] forState:UIControlStateNormal];
    [cell.favoriteButton setBackgroundImage:[UIImage imageNamed:@"icn_favorite_on"] forState:UIControlStateSelected];
    [cell.favoriteButton setSelected:tweet.favorited];
    
    cell.replyButton.tag = indexPath.row;
    cell.retweetButton.tag = indexPath.row;
    cell.favoriteButton.tag = indexPath.row;
    [cell.replyButton addTarget:self action:@selector(onReply:) forControlEvents:UIControlEventTouchUpInside];
    [cell.retweetButton addTarget:self action:@selector(onRetweet:) forControlEvents:UIControlEventTouchUpInside];
    [cell.favoriteButton addTarget:self action:@selector(onFavorite:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // maximum cell height
    static CGFloat maxHeight = 160.0f;
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    CGFloat width = self.view.frame.size.width;
    CGRect frame = [tweet.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                            context:nil];
    
    return (maxHeight - 68.0f + frame.size.height - (tweet.retweeted_by ? 0.0f : 24.0f));
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // navigate to Tweet view controller
    TweetVC *vc = [[TweetVC alloc] initWithNibName:@"TweetVC" bundle:nil];
    vc.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

// UITableView scrolling; for loading more tweets
// Reference: http://stackoverflow.com/questions/5137943/how-to-know-when-uitableview-did-scroll-to-bottom-in-iphone
static bool isLoadingMoreTweets = NO;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    //NSLog(@"offset: %f, content.height: %f, bounds.height: %f, inset.top: %f, inset.bottom: %f, pos: %f of %f", offset.y, size.height, bounds.size.height, inset.top, inset.bottom, y, h);
    
    if (h == 0) return;  // Prevent loading more rows first time around, when scroll view content is not yet loaded
    
    float reload_distance = 10;
    if (!isLoadingMoreTweets && y > h + reload_distance) {
        // Load more tweets
        Tweet *lastTweet = [self.tweets lastObject];
        isLoadingMoreTweets = YES;
        [[TwitterClient instance] homeTimelineWithCount:20 sinceId:@"0" maxId:lastTweet.tweet_id success:^(AFHTTPRequestOperation *operation, id response) {
            NSLog(@"%@", response);
            isLoadingMoreTweets = NO;
            if ([lastTweet.tweet_id intValue] > 0) {
                [self.tweets addObjectsFromArray:[Tweet tweetsWithArray:response]];
            } else {
                self.tweets = [Tweet tweetsWithArray:response];
            }
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            isLoadingMoreTweets = NO;
        }];
        /*
         // Simulate tweet loading
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
         NSLog(@"More tweets loaded");
         isLoadingMoreTweets = NO;
         });
         */
    }
}

#pragma mark - Compose view delegate methods

// Pass data from child view controller to parent view controller
// Reference: http://stackoverflow.com/questions/6203799/dismissmodalviewcontroller-and-pass-data-back
- (void)composeViewControllerDismissed:(Tweet *)tweet
{
    // push new tweet to top of timeline display
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - Private methods

- (void)onSignOutButton
{
    [User setCurrentUser:nil];
}

- (void)onCompose
{
    // navigate to Compose view controller
    ComposeVC *vc = [[ComposeVC alloc] initWithNibName:@"ComposeVC" bundle:nil];
    vc.delegate = self;
    vc.user = [User currentUser];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onReply:(UIButton *)sender {
    ComposeVC *vc = [[ComposeVC alloc] initWithNibName:@"ComposeVC" bundle:nil];
    vc.replyToTweet = self.tweets[sender.tag];
    vc.user = [User currentUser];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onRetweet:(UIButton *)sender {
    Tweet *tweet = self.tweets[sender.tag];
    sender.selected = !sender.selected;
    if (sender.selected) {
        tweet.retweeted = YES;
        tweet.retweet_count += 1;
        
        // Retweet via Twitter API
        [[TwitterClient instance] retweetTweet:tweet.tweet_id success:^(AFHTTPRequestOperation *operation, id response) {
            tweet.retweet_id = [response objectForKey:@"id_str"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Retweet fail!: %@", error);
            tweet.retweeted = NO;
            tweet.retweet_count -= 1;
        }];
    }
    else {
        tweet.retweeted = NO;
        tweet.retweet_count -= 1;
        
        // Remove retweet via Twitter API
        [[TwitterClient instance] destroyTweet:tweet.retweet_id success:^(AFHTTPRequestOperation *operation, id response) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Destroy retweet fail!: %@", error);
            tweet.retweeted = YES;
            tweet.retweet_count += 1;
        }];
    }
}

- (void)onFavorite:(UIButton *)sender {
    Tweet *tweet = self.tweets[sender.tag];
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        tweet.favorited = YES;
        tweet.favorite_count += 1;
        
        // Favorite via Twitter API
        [[TwitterClient instance] favoriteTweet:tweet.tweet_id success:^(AFHTTPRequestOperation *operation, id response) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Favorite fail!: %@", error.localizedDescription);
            tweet.favorited = NO;
            tweet.favorite_count -= 1;
        }];
    }
    else {
        tweet.favorited = NO;
        tweet.favorite_count -= 1;
        
        // Unfavorite via Twitter API
        [[TwitterClient instance] unfavoriteTweet:tweet.tweet_id success:^(AFHTTPRequestOperation *operation, id response) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Unfavorite fail!: %@", error.localizedDescription);
            tweet.favorited = YES;
            tweet.favorite_count += 1;
        }];
    }
}

- (void)reload
{
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Network error
        [self.refreshControl endRefreshing];
        NSLog(@"%@", error);
    }];
}

- (void)onError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Oops!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


@end
