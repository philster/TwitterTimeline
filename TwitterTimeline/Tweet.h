//
//  Tweet.h
//  TwitterTimeline
//
//  Created by Phil Wee on 2/2/14.
//  Copyright (c) 2014 Philster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *screen_name;
@property (nonatomic, strong, readonly) NSString *profile_image_url;
@property (nonatomic, strong, readonly) NSString *tweet_id;
@property (nonatomic, strong) NSString *retweet_id;
@property (nonatomic, assign) NSUInteger retweet_count;
@property (nonatomic, assign) NSUInteger favorite_count;
@property (nonatomic, assign) BOOL retweeted;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong, readonly) NSString *created_at_short;
@property (nonatomic, strong, readonly) NSString *created_at_veryshort;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
