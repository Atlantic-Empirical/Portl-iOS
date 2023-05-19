//
//  PTKOnboardingInviteViewController.h
//  portkey
//
//  Created by Adam Bellard on 7/26/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKOnboardingBaseViewController.h"

@interface PTKOnboardingInviteViewController : PTKOnboardingBaseViewController

@property (nonatomic, strong) NSArray *invites;
@property (nonatomic, strong) NSArray *recommendedRooms;
@property (nonatomic, strong) NSString *roomSlug;

@end
