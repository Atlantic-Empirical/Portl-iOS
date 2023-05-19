//
//  PTKCall.h
//  portkey
//
//  Created by Rodrigo Sieiro on 8/6/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@interface PTKCall : PTKModel

- (NSString *)roomId;
- (NSDate *)createdAt;
- (NSDate *)updatedAt;
- (NSArray<PTKUser *> *)publishers;

- (instancetype)initWithRoomId:(NSString *)roomId caller:(PTKUser *)user;
- (BOOL)hasPublisher:(NSString *)userId;
- (BOOL)currentUserIsPublishing;

@end
