//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
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

- (NSUInteger)retweet_count {
    return [[self.data valueOrNilForKeyPath:@"retweet_count"] integerValue];
}

- (NSUInteger)favorite_count {
    return [[self.data valueOrNilForKeyPath:@"favorite_count"] integerValue];
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

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
