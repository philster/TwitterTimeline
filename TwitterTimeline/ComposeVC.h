//
//  ComposeVC.h
//  TwitterTimeline
//
//  Created by Phil Wee on 2/2/14.
//  Copyright (c) 2014 Philster. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ComposeDelegate <NSObject>

- (void)composeViewControllerDismissed:(Tweet *)tweet;

@end

@interface ComposeVC : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) Tweet *replyToTweet;
@property (nonatomic, weak) User *user;
@property (nonatomic, weak) IBOutlet UITextView *tweetTextView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *screenNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *profileImage;
@property (nonatomic, assign) id<ComposeDelegate> delegate;

@end
