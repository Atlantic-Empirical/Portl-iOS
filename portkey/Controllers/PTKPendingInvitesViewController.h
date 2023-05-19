//
//  PTKPendingInvitesViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 1/6/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@interface PTKPendingInvitesViewController : PTKBaseViewController

+ (NSArray *)pendingRooms;
+ (void)markPendingRoomsAsSeen:(NSArray *)rooms;

- (instancetype)initWithPendingInvites:(NSArray *)pendingInvites;

@end
