//
//  PTKOnboardingNotificationsViewController.h
//  portkey
//
//  Created by Seth Samuel on 2/23/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKOnboardingBaseViewController.h"

@protocol PTKOnboardingNotificationsViewControllerDelegate <NSObject>

- (void)onboardingNotificationsDidComplete:(BOOL)authorized;

@end

@interface PTKOnboardingNotificationsViewController : PTKOnboardingBaseViewController
@property (weak) id<PTKOnboardingNotificationsViewControllerDelegate> delegate;
@end
