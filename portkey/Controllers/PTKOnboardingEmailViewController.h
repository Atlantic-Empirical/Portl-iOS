//
//  PTKOnboardingPasswordViewController.h
//  portkey
//
//  Created by Adam Bellard on 2/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "portkey-Swift.h"
#import "PTKOnboardingBaseViewController.h"


@protocol PTKOnboardingEmailViewControllerDelegate <NSObject>

- (void)onboardingEmailBackButtonPressed;

@end

@interface PTKOnboardingEmailViewController : PTKOnboardingBaseViewController

@property (nonatomic) PTKOnboardingTextField *emailTextField;
@property (nonatomic) PTKOnboardingTextField *passwordTextField;

@property (nonatomic, weak) id<PTKOnboardingEmailViewControllerDelegate>delegate;

@end
