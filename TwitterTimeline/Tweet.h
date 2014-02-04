//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *screen_name;
@property (nonatomic, strong, readonly) NSString *profile_image_url;
@property (nonatomic, readonly) NSUInteger retweet_count;
@property (nonatomic, readonly) NSUInteger favorite_count;
@property (nonatomic, readonly) BOOL retweeted;
@property (nonatomic, readonly) BOOL favorited;
@property (nonatomic, strong, readonly) NSString *created_at;
@property (nonatomic, strong, readonly) NSString *created_at_short;
@property (nonatomic, strong, readonly) NSString *created_at_veryshort;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
