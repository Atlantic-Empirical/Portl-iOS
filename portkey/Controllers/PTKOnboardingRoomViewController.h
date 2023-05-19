//
//  PTKOnboardingRoomViewController.h
//  portkey
//
//  Created by Adam Bellard on 2/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKOnboardingBaseViewController.h"

@interface PTKOnboardingRoomViewController : PTKOnboardingBaseViewController

- (instancetype)initWithInvites:(NSArray *)invites recommendedRooms:(NSArray *)recommendedRooms andRoomSlug:(NSString *)roomSlug;

@end
