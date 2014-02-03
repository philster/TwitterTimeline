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
    self.createdAtLabel.text = self.tweet.created_at;
    
    NSURL *url = [[NSURL alloc] initWithString:self.tweet.profile_image_url];
    [self.profileImage setImageWithURL:url];
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

@end
