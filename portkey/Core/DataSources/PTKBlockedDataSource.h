//
//  PTKBlockedDataSource.h
//  portkey
//
//  Created by Daniel Amitay on 1/11/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKPaginatedDataSource.h"
#import "PTKBlocked.h"

@interface PTKBlockedDataSource : PTKPaginatedDataSource

- (void)blockUser:(PTKUser *)user withReason:(NSString *)reason;
- (void)unblockUser:(PTKUser *)user;
- (BOOL)isUserBlocked:(NSString *)userId;

@end
