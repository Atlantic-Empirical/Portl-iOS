//
//  PTKBlocked.h
//  portkey
//
//  Created by Daniel Amitay on 1/11/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@interface PTKBlocked : PTKModel

- (PTKUser *)user;
- (NSString *)reason;
- (NSDate *)createdAt;

+ (PTKBlocked *)blockedWithUser:(PTKUser *)user andReason:(NSString *)reason;

@end
