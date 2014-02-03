//
//  ComposeVC.m
//  TwitterTimeline
//
//  Created by Phil Wee on 2/2/14.
//  Copyright (c) 2014 Philster. All rights reserved.
//

#import "ComposeVC.h"
#import "UIImageView+AFNetworking.h"

@interface ComposeVC ()

@end

@implementation ComposeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Compose";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // Create Cancel and Tweet buttons
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];

    // Populate tweet view data
    self.textLabel.text = self.tweet.text;
    self.nameLabel.text = self.tweet.name;
    self.screenNameLabel.text = self.tweet.screen_name;
    
    //NSURL *url = [[NSURL alloc] initWithString:self.tweet.profile_image_url];
    //[self.profileImage setImageWithURL:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onTweet
{
    NSLog(@"Tweet");
    // save stuff then dismiss
    [self dismiss];
}

@end
