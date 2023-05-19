//
//  PTKOnboardingUsernameViewController.h
//  portkey
//
//  Created by Robert Reeves on 7/26/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"
#import "PTKOnboardingBaseViewController.h"

@protocol PTKOnboardingUsernameViewControllerDelegate <NSObject>

@optional
- (void)userDidCompleteUsernameSelection;

@end


@interface PTKOnboardingUsernameViewController : PTKOnboardingBaseViewController


@property (nonatomic, weak) id<PTKOnboardingUsernameViewControllerDelegate>delegate;

@end
