//
//  TweetCell.m
//  TwitterTimeline
//
//  Created by Phil Wee on 2/2/14.
//  Copyright (c) 2014 Philster. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    self.favoriteButton = sender;
    self.favoriteButton.selected = !self.favoriteButton.selected;
    
    // post favorite via api
    
    if (self.favoriteButton.selected) {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"icn_favorite_on"] forState:UIControlStateNormal];
    } else {
        [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"icn_favorite_off"] forState:UIControlStateNormal];
    }
}

@end
