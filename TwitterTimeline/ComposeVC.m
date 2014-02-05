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
        self.title = @"140";
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
    self.textView.text = @"";
    //if (self.replyTo) {
    //    self.textView.text = [NSString stringWithFormat:@"%@ ", self.replyTo.screenName];
    //}
    NSDictionary *user = [[User currentUser] data];
    self.nameLabel.text = [user valueOrNilForKeyPath:@"name"];
    self.screenNameLabel.text = [user valueOrNilForKeyPath:@"screen_name"];
    
    NSURL *url = [NSURL URLWithString:[user valueOrNilForKeyPath:@"profile_image_url"]];
    [self.profileImage setImageWithURL:url];
    
    [self.textView becomeFirstResponder];
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
    // Tweet via Twitter API
    [[TwitterClient instance] composeTweet:self.textView.text success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Success: %@", response);
        self.tweet.tweet_id = [response objectForKey:@"id_str"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Compose fail!: %@", error);
    }];
    
    // Save stuff then dismiss
    [self dismiss];
}

@end
