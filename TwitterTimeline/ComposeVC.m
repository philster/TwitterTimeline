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

@synthesize delegate;

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
    self.tweetTextView.text = @"";
    if (self.replyToTweet) {
        self.tweetTextView.text = [NSString stringWithFormat:@"%@ ", self.replyToTweet.screen_name];
    }
    self.nameLabel.text = [self.user valueOrNilForKeyPath:@"name"];
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", [self.user valueOrNilForKeyPath:@"screen_name"]];
    
    NSURL *url = [NSURL URLWithString:[self.user valueOrNilForKeyPath:@"profile_image_url"]];
    [self.profileImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    [self.tweetTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text view delegate

// Tweet character counter
// Reference: http://stackoverflow.com/questions/5258416/how-to-implement-a-simple-live-word-count-in-a-uitextview
- (void)textViewDidChange:(UITextView *)textView
{
    int len = [textView.text length];
    self.title = [NSString stringWithFormat:@"%d", 140-len];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0) {
        if([textView.text length] != 0) {
            return YES;
        }
    }
    else if([[textView text] length] > 139) {
        return NO;
    }
    return YES;
}

#pragma mark - Private methods

- (void)dismiss
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onTweet
{
    if (self.replyToTweet) {
        // Reply via Twitter API
        [[TwitterClient instance] replyTweet:self.tweetTextView.text tweetId:self.replyToTweet.tweet_id success:^(AFHTTPRequestOperation *operation, id response) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Reply fail!: %@", error.localizedDescription);
        }];
    } else {
        // Tweet via Twitter API
        [[TwitterClient instance] composeTweet:self.tweetTextView.text success:^(AFHTTPRequestOperation *operation, id response) {
            // Pass data from child view controller to parent view controller
            // Reference: http://stackoverflow.com/questions/6203799/dismissmodalviewcontroller-and-pass-data-back
            if([self.delegate respondsToSelector:@selector(composeViewControllerDismissed:)]) {
                Tweet *tweet = [[Tweet alloc] initWithDictionary:response];
                [self.delegate composeViewControllerDismissed:tweet];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Compose fail!: %@", error.localizedDescription);
        }];
    }
    
    // Save stuff then dismiss
    [self dismiss];
}

@end
