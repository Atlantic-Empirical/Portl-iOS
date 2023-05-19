//
//  PTKAutomateOnboarding.h
//  portkey
//
//  Created by Nick Galasso on 11/21/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PTKOnboard) {
    PTKOnboardGetStarted = 1337,
    PTKOnboardPhoneNumber,
    PTKOnboardLetsGo,
    PTKOnboardEnterCodeField,
    PTKOnboardAvatarView,
    PTKOnboardNameField,
    PTKOnboardEmailField,
    PTKOnboardUsernameField,
    PTKOnboardUsernameNextButton,
    PTKOnboardAllowContactsButton,
    PTKOnboardFinished,
    PTKOnboardButtonTag
};

#if TARGET_IPHONE_SIMULATOR
static BOOL const shouldAutomateOnboarding = YES;
static NSString *const defaultPhoneNumber = @""; //use format @"(800) 555-4444"
#endif

extern void PTKOnboardingSetOnboardState(PTKOnboard state);

@interface PTKAutomateOnboarding : NSObject
+(PTKAutomateOnboarding*)sharedInstance;
-(void)doStuff:(UIView*)sender;
@end
