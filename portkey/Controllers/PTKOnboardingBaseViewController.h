//
//  PTKOnboardingBaseViewController.h
//  portkey
//
//  Created by Adam Bellard on 2/17/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"


@interface PTKOnboardingBaseViewController : PTKBaseViewController

@property (nonatomic, strong) PTKSession *session;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic) CAGradientLayer *backgroundGradient;

- (void)onDidVerifyCode:(PTKAPIResponse *)response;
- (void)onDidFetchMe:(PTKAPIResponse *)response;
- (void)acceptAllPendingRoomsAndLogin;
- (void)identifyUser;
- (void)logInToSession;
- (void)showAlertForError:(NSError *)error;

- (void)connectFacebook;
- (void)didConnectFacebook;

@end
