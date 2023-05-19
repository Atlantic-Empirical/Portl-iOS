//
//  PTKBlocked.m
//  portkey
//
//  Created by Daniel Amitay on 1/11/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBlocked.h"

@implementation PTKBlocked

MODEL_SUBPROPERTY(user, @"user", PTKUser)
MODEL_STRING(reason, @"reason", nil)
MODEL_DATE(createdAt, @"createdAt", nil)

- (NSString *)oid {
    return self.user.oid;
}

+ (PTKBlocked *)blockedWithUser:(PTKUser *)user andReason:(NSString *)reason {
    if (!user) return nil;

    NSDictionary *json = @{@"user": user,
                           @"reason": reason ?: [NSNull null],
                           @"createdAt": [PTKDatetimeUtility iso8601StringFromDate:[NSDate date]]};

    return [[PTKBlocked alloc] initWithJSON:json];
}

@end
