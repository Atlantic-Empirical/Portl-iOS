//
//  PTKInvite.m
//  portkey
//
//  Created by Adam Bellard on 11/18/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import "PTKInvite.h"

@implementation PTKInvite

MODEL_DATE(createdAt, @"createdAt", nil)
MODEL_SUBPROPERTY(user, @"user", PTKUser)
MODEL_SUBPROPERTY(room, @"room", PTKRoom)

- (NSString *)oid {
    return [NSString stringWithFormat:@"room=%@&user=%@", self.room.oid, self.user.oid];
}

@end
