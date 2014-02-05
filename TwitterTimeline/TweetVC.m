//
//  TweetVC.m
//  TwitterTimeline
//
//  Created by Phil Wee on 2/2/14.
//  Copyright (c) 2014 Philster. All rights reserved.
//

#import "TweetVC.h"
#import "ComposeVC.h"
#import "UIImageView+AFNetworking.h"

@interface TweetVC ()

@end

@implementation TweetVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Tweet";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Create Reply buttons
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply:)];
    
    // Populate tweet view data
    self.textLabel.text = self.tweet.text;
    self.nameLabel.text = self.tweet.name;
    self.screenNameLabel.text = self.tweet.screen_name;
    self.textLabel.text = self.tweet.text;
    [self.textLabel sizeToFit];
    self.createdAtLabel.text = self.tweet.created_at_short;
    if (self.tweet.retweeted_by) {
        self.retweetedByLabel.text = [NSString stringWithFormat:@"%@ retweeted", self.tweet.retweeted_by];
    } else {
        self.retweetedByLabel.hidden = YES;
        self.heightConstraint.constant = 0;
    }
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d RETWEETS", self.tweet.retweet_count];
    self.favoriteCountLabel.text =  [NSString stringWithFormat:@"%d FAVORITES", self.tweet.favorite_count];
    
    NSURL *url = [[NSURL alloc] initWithString:self.tweet.profile_image_url];
    [self.profileImage setImageWithURL:url];
    
    [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"icn_retweet_off"] forState:UIControlStateNormal];
    [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"icn_retweet_on"] forState:UIControlStateSelected];
    [self.retweetButton setSelected:self.tweet.retweeted];
    
    [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"icn_favorite_off"] forState:UIControlStateNormal];
    [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"icn_favorite_on"] forState:UIControlStateSelected];
    [self.favoriteButton setSelected:self.tweet.favorited];
    
    //[self.replyButton addTarget:self action:@selector(onReply:) forControlEvents:UIControlEventTouchUpInside];
    //[self.retweetButton addTarget:self action:@selector(onRetweet:) forControlEvents:UIControlEventTouchUpInside];
    //[self.favoriteButton addTarget:self action:@selector(onFavorite:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (IBAction)onReply:(UIButton *)sender {
    NSLog(@"onReply: %d", sender.tag);
    
    ComposeVC *vc = [[ComposeVC alloc] initWithNibName:@"ComposeVC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onRetweet:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.tweet.retweeted = YES;
        self.tweet.retweet_count += 1;
        
        // Retweet via Twitter API
        [[TwitterClient instance] retweetTweet:self.tweet.tweet_id success:^(AFHTTPRequestOperation *operation, id response) {
            self.tweet.retweeted = YES;
            self.tweet.retweet_id = [response objectForKey:@"id_str"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Retweet fail!: %@", error);
        }];
    }
    else {
        self.tweet.retweeted = NO;
        self.tweet.retweet_count -= 1;
        
        // Remove retweet via Twitter API
        [[TwitterClient instance] destroyTweet:self.tweet.retweet_id success:^(AFHTTPRequestOperation *operation, id response) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Destroy retweet fail!: %@", error);
        }];
    }
    // Update views
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d RETWEETS", self.tweet.retweet_count];
    self.favoriteCountLabel.text =  [NSString stringWithFormat:@"%d FAVORITES", self.tweet.favorite_count];
}

- (IBAction)onFavorite:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        self.tweet.favorited = YES;
        self.tweet.favorite_count += 1;
        
        // Favorite via Twitter API
        [[TwitterClient instance] favoriteTweet:self.tweet.tweet_id success:^(AFHTTPRequestOperation *operation, id response) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Favorite fail!: %@", error.localizedDescription);
        }];
    }
    else {
        self.tweet.favorited = NO;
        self.tweet.favorite_count -= 1;
        
        // Unfavorite via Twitter API
        [[TwitterClient instance] unfavoriteTweet:self.tweet.tweet_id success:^(AFHTTPRequestOperation *operation, id response) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Unfavorite fail!: %@", error.localizedDescription);
        }];
    }
    // Update views
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d RETWEETS", self.tweet.retweet_count];
    self.favoriteCountLabel.text =  [NSString stringWithFormat:@"%d FAVORITES", self.tweet.favorite_count];
}

@end
