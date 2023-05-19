//
//  PTKOnboardingProfileViewController.h
//  portkey
//
//  Created by Adam Bellard on 2/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "portkey-Swift.h"
#import "PTKOnboardingBaseViewController.h"

@protocol PTKOnboardingProfileViewControllerDelegate <NSObject>

@optional
- (void)userDidCompleteNewUserSignup; 
- (void)userDidRequestSignIn;

@end

@interface PTKOnboardingProfileViewController : PTKOnboardingBaseViewController

@property (nonatomic) PTKOnboardingTextField *emailTextField;

@property (nonatomic, weak) id<PTKOnboardingProfileViewControllerDelegate>delegate;

@end
