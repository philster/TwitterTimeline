//
//  Tweet.m
//  TwitterTimeline
//
//  Created by Phil Wee on 2/2/14.
//  Copyright (c) 2014 Philster. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)text {
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSString *)name {
    NSDictionary *user = [self.data valueOrNilForKeyPath:@"user"];
    return [user valueOrNilForKeyPath:@"name"];
}

- (NSString *)screen_name {
    NSDictionary *user = [self.data valueOrNilForKeyPath:@"user"];
    return [@"@" stringByAppendingString: [user valueOrNilForKeyPath:@"screen_name"] ];
}

- (NSString *)profile_image_url {
    NSDictionary *user = [self.data valueOrNilForKeyPath:@"user"];
    return [user valueOrNilForKeyPath:@"profile_image_url"];
}

- (NSString *)tweet_id {
    return [self.data valueOrNilForKeyPath:@"id_str"];
}

@synthesize retweet_id = _retweet_id;
- (NSString *)retweet_id {
    if (!_retweet_id) {
        NSDictionary *user_retweet = [self.data valueOrNilForKeyPath:@"current_user_retweet"];
        return [user_retweet valueOrNilForKeyPath:@"id_str"];
    }
    return _retweet_id;
}

- (NSString *)retweeted_by {
    if ([self.data valueOrNilForKeyPath:@"retweeted_status"]) {
        NSDictionary *user = [self.data valueOrNilForKeyPath:@"user"];
        return [user valueOrNilForKeyPath:@"name"];
    }
    return nil;
}

@synthesize retweet_count = _retweet_count;
- (NSUInteger)retweet_count {
    return _retweet_count ? _retweet_count : [[self.data valueOrNilForKeyPath:@"retweet_count"] integerValue];
}

@synthesize favorite_count = _favorite_count;
- (NSUInteger)favorite_count {
    return _favorite_count ? _favorite_count : [[self.data valueOrNilForKeyPath:@"favorite_count"] integerValue];
}

- (BOOL)retweeted {
    return [[self.data valueOrNilForKeyPath:@"retweeted"] boolValue];
}

- (BOOL)favorited {
    return [[self.data valueOrNilForKeyPath:@"favorited"] boolValue];
}

- (NSString *)created_at {
    return [self.data valueOrNilForKeyPath:@"created_at"];
}

static NSDateFormatter *dateFormatter;
- (NSString *)created_at_short
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    // Twitter date format: @"Wed Jan 01 00:00:00 +0000 2014"
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss vvvv yyyy"];
    NSDate *createdDate = [dateFormatter dateFromString:self.created_at];
    [dateFormatter setDateFormat:@"M/d/yy HH:mm a"];
    return [dateFormatter stringFromDate:createdDate];
}

- (NSString *)created_at_veryshort
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    // Twitter date format: @"Wed Jan 01 00:00:00 +0000 2014"
    [dateFormatter setDateFormat:@"EEE MMM dd HH:mm:ss vvvv yyyy"];
    NSDate *createdDate = [dateFormatter dateFromString:self.created_at];
    NSTimeInterval timeInterval = -[createdDate timeIntervalSinceNow];
    if (timeInterval < 60.0) {
        return @"Just now";
    }
    else if (timeInterval < 3600.0) {
        return [NSString stringWithFormat:@"%dm", (int)round(timeInterval / 60.0)];
    }
    else if (timeInterval < 86400.0) {
        return [NSString stringWithFormat:@"%dh", (int)round(timeInterval / 3600.0)];
    }
    else {
        [dateFormatter setDateFormat:@"dd/MM/yy"];
        return [dateFormatter stringFromDate:createdDate];
    }
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
