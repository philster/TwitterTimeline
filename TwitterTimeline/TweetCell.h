//
//  TweetCell.h
//  TwitterTimeline
//
//  Created by Phil Wee on 2/2/14.
//  Copyright (c) 2014 Philster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *textLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *screenNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *profileImage;
@property (nonatomic, weak) IBOutlet UILabel *createdAtLabel;
@property (nonatomic, weak) IBOutlet UIButton *replyButton;
@property (nonatomic, weak) IBOutlet UIButton *retweetButton;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;
@property (nonatomic, weak) IBOutlet UILabel *retweetedByLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;

@end
