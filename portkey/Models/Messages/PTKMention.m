//
//  PTKMention.m
//  portkey
//
//  Created by Daniel Amitay on 6/7/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKMention.h"

@implementation PTKMention

MODEL_STRING(userId, @"userId", nil)
MODEL_INT(start, @"rangeStart", 0)
MODEL_INT(end, @"rangeEnd", 0)

- (instancetype)initWithUserId:(NSString *)userId andRange:(NSRange)range {
    if (!userId) return nil;

    return [self initWithJSON:@{@"userId": userId,
                                @"rangeStart": @(range.location),
                                @"rangeEnd": @(range.location + range.length)}];
}

- (NSRange)range {
    int start = self.start;
    int length = self.end - start;
    return NSMakeRange(start, length);
}

@end
