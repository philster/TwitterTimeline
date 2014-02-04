//
//  TweetVC.m
//  TwitterTimeline
//
//  Created by Phil Wee on 2/2/14.
//  Copyright (c) 2014 Philster. All rights reserved.
//

#import "TweetVC.h"
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply)];
    
    // Populate tweet view data
    self.textLabel.text = self.tweet.text;
    self.nameLabel.text = self.tweet.name;
    self.screenNameLabel.text = self.tweet.screen_name;
    self.textLabel.text = self.tweet.text;
    [self.textLabel sizeToFit];
    self.createdAtLabel.text = self.tweet.created_at_short;
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d RETWEETS", self.tweet.retweet_count];
    self.favoriteCountLabel.text =  [NSString stringWithFormat:@"%d FAVORITES", self.tweet.favorite_count];
    
    NSURL *url = [[NSURL alloc] initWithString:self.tweet.profile_image_url];
    [self.profileImage setImageWithURL:url];
    
    [self.retweetButton setBackgroundImage:[UIImage imageNamed:(self.tweet.retweeted ? @"icn_retweet_on" : @"icn_retweet_off")] forState:UIControlStateNormal];
    [self.favoriteButton setBackgroundImage:[UIImage imageNamed:(self.tweet.favorited ? @"icn_favorite_on" : @"icn_favorite_off")] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)onReply
{
    NSLog(@"Reply");
}

- (IBAction)replyAction:(id)sender {
    NSLog(@"Reply");
}

- (IBAction)retweetAction:(id)sender {
    self.retweetButton = (UIButton *)sender;
    self.retweetButton.selected = !self.retweetButton.selected;
    
    // post retweet via api
    
    if (self.retweetButton.selected) {
        [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"icn_retweet_on"] forState:UIControlStateNormal];
    } else {
        [self.retweetButton setBackgroundImage:[UIImage imageNamed:@"icn_retweet_off"] forState:UIControlStateNormal];
    }
}

- (IBAction)favoriteAction:(id)sender {
    self.favoriteButton = (UIButton *)sender;
    self.favoriteButton.selected = !self.favoriteButton.selected;
    
    // post favorite via api
    
    if (self.favoriteButton.selected) {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"icn_favorite_on"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"icn_favorite_off"] forState:UIControlStateNormal];
    }
}

@end
