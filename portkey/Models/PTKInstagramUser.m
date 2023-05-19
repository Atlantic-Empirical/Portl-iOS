//
//  PTKInstagramUser.m
//  portkey
//
//  Created by Rodrigo Sieiro on 6/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKInstagramUser.h"

@implementation PTKInstagramUser

MODEL_STRING(userName, @"username", nil)
MODEL_STRING(displayName, @"displayName", nil)

- (NSString *)oid {
    NSString *oid = [self retrieveStringProperty:@"id" defaultValue:nil];

    if (!oid) {
        oid = [self retrieveStringProperty:@"instagramId" defaultValue:nil];
    }

    return oid;
}

- (NSString *)avatar {
    NSString *avatar = [self retrieveStringProperty:@"avatar" defaultValue:nil];

    if (!avatar) {
        avatar = [self retrieveStringProperty:@"profilePicture" defaultValue:nil];
    }

    return avatar;
}

@end
