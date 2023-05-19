//
//  PTKRoomMember.h
//  portkey
//
//  Created by Rodrigo Sieiro on 7/5/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@interface PTKRoomMember : PTKModel

- (NSString *)roomId;
- (NSString *)state;
- (NSString *)invitedBy;
- (PTKUser *)user;
- (NSDate *)createdAt;

- (BOOL)isActive;
- (BOOL)isRequested;
- (BOOL)isPending;

@end
