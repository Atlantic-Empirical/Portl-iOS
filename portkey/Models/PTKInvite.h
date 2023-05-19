//
//  PTKInvite.h
//  portkey
//
//  Created by Adam Bellard on 11/18/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@interface PTKInvite : PTKModel

- (NSDate *)createdAt;
- (PTKRoom *)room;
- (PTKUser *)user;

@end
