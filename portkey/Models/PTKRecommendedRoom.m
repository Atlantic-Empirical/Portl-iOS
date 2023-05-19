//
//  PTKRecommendedRoom.m
//  portkey
//
//  Created by Rodrigo Sieiro on 14/1/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKRecommendedRoom.h"

@implementation PTKRecommendedRoom

MODEL_SUBPROPERTY(room, @"room", PTKRoom)
MODEL_ARRAY(users, @"users", PTKUser)
MODEL_DOUBLE(score, @"score", 0)

- (NSString *)oid {
    return self.room.oid;
}

@end
