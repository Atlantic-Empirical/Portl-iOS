//
//  PTKAutomateOnboarding.m
//  portkey
//
//  Created by Nick Galasso on 11/21/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKAutomateOnboarding.h"
#import "PTKCodeInputView.h"
#import "PTKEditableAvatarView.h"
#import "PTKPhoneInputView.h"
#import "portkey-Swift.h"


@interface UIButton (Tap)

-(void)tap;

@end

@implementation UIButton (Tap)

-(void)tap{
    [self sendActionsForControlEvents: UIControlEventTouchUpInside];
}

@end

int buttonTag = PTKOnboardButtonTag;
static PTKOnboard _onboardingState = PTKOnboardGetStarted;

void PTKOnboardingSetOnboardState(PTKOnboard state){
#ifndef __clang_analyzer__

#ifndef TARGET_IPHONE_SIMULATOR
    return;
#endif

    _onboardingState = state;
    
    UIWindow *w = [UIApplication sharedApplication].keyWindow;
    UIButton *b = [w viewWithTag:buttonTag];
    
    switch (_onboardingState) {
        case PTKOnboardGetStarted:{
            [b setTitle:@"tap to get started" forState:UIControlStateNormal];
            break;
        }
        case PTKOnboardPhoneNumber:{
#if TARGET_IPHONE_SIMULATOR
            NSString *title = [NSString stringWithFormat:@"tap to enter %@ and continue", defaultPhoneNumber.length > 0 ? defaultPhoneNumber : @"random phone#"];
            [b setTitle:title forState:UIControlStateNormal];
#else
            [b setTitle:@"tap to enter random phone# and continue" forState:UIControlStateNormal];
#endif
            break;
            
        }
        case PTKOnboardLetsGo:{
            
            break;
        }
        case PTKOnboardEnterCodeField:{
            [b setTitle:@"tap to enter 0706 and continue" forState:UIControlStateNormal];
            break;
        }
        case PTKOnboardAvatarView:{
            [b setTitle:@"tap to set an avatar and continue" forState:UIControlStateNormal];
            break;
        }
        case PTKOnboardNameField:{
            [b setTitle:@"tap to fill empty fields and continue" forState:UIControlStateNormal];
            break;
        }
        case PTKOnboardUsernameField:{
            [b setTitle:@"tap to fill username and continue" forState:UIControlStateNormal];
            break;
        }
        case PTKOnboardAllowContactsButton:{
            [b setTitle:@"tap to dismiss contacts prompt" forState:UIControlStateNormal];
            break;
        }
        case PTKOnboardFinished:{
            [b setTitle:@"tap to get rid of this button" forState:UIControlStateNormal];
            break;
        }
        default:break;
    }
    [b sizeToFit];
#endif
}

void runLoop(double i){
    NSRunLoop* loop = [NSRunLoop currentRunLoop];
    [loop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:i]];
}

void PTKAutomateOnboardingHandleOnboardState(){
#ifndef __clang_analyzer__
    UIWindow *w = [UIApplication sharedApplication].keyWindow;
    
    switch (_onboardingState) {
        case PTKOnboardGetStarted:{
            UIButton *b = [w viewWithTag:PTKOnboardGetStarted];
            [b tap];
            break;
        }
        case PTKOnboardPhoneNumber:{
#if TARGET_IPHONE_SIMULATOR
            UIButton *getStarted = [w viewWithTag:PTKOnboardGetStarted];
            [getStarted tap];
            PTKPhoneInputView *input = [w viewWithTag:PTKOnboardPhoneNumber];
            
            NSString *num;
            
            if (defaultPhoneNumber.length){
                num = defaultPhoneNumber;
            } else {
                NSNumber* rando = @(arc4random_uniform(RAND_MAX));
                NSString *last4 = [rando.stringValue substringToIndex:4];
                num = [NSString stringWithFormat:@"(800) 555-%@",last4];
            }
            
            [input.phoneTextField.delegate textField:input.phoneTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:num];
            UIButton *letsGo = [w viewWithTag:PTKOnboardLetsGo];
            [letsGo tap];
            break;
#endif
        }
            
        case PTKOnboardEnterCodeField:{
            PTKCodeInputView *codeInput = [w viewWithTag:PTKOnboardEnterCodeField];
            [codeInput textField:codeInput.hiddenTextField shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@"0706"];
            UIButton *letsGo = [w viewWithTag:PTKOnboardLetsGo];
            [letsGo tap];
            break;
        }
        case PTKOnboardAvatarView:{
            PTKEditableAvatarView *avatar = [w viewWithTag:PTKOnboardAvatarView];
            UIImage *doge = [UIImage imageNamed:@"doge_avatar"];
            [avatar setImage:doge withSource:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        }
        case PTKOnboardNameField:{
            UITextField *name = [w viewWithTag:PTKOnboardNameField];
            if (!name.text.length){
                name.text = @"Doge Doggerson";
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                [name.delegate performSelector:@selector(myTextFieldDidChange:) withObject:name];
#pragma clang diagnostic pop
            }
            
            UITextField *email = [w viewWithTag:PTKOnboardEmailField];
            if (!email.text.length){
                NSNumber* rando = @(arc4random_uniform(RAND_MAX));
                
                email.text = [NSString stringWithFormat:@"doge+%@@airtime.com", rando.stringValue];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                [email.delegate performSelector:@selector(myTextFieldDidChange:) withObject:email];
#pragma clang diagnostic pop
            }
            
            
            _onboardingState = PTKOnboardAllowContactsButton;

            NSNumber* rando = @(arc4random_uniform(RAND_MAX));
            NSString *last6 = [rando.stringValue substringToIndex:6];
            UITextField *input = [w viewWithTag:PTKOnboardUsernameField];
            NSString* username = [NSString stringWithFormat:@"doge%@", last6];
            input.text = username;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
            [input.delegate performSelector:@selector(myTextFieldDidChange:) withObject:input];
#pragma clang diagnostic pop
            runLoop(2);
            
            UIButton *continueButton = [w viewWithTag:PTKOnboardUsernameNextButton];
            
            if (continueButton.isEnabled){
                [continueButton tap];
            }
            break;
        }
        case PTKOnboardAllowContactsButton:{
            UIButton *contacts = [w viewWithTag:PTKOnboardAllowContactsButton];
            [contacts tap];
            PTKOnboardingSetOnboardState(PTKOnboardFinished);
            break;
        }
        case PTKOnboardFinished:{
            UIView *b = [w viewWithTag:buttonTag];
            [b removeFromSuperview];
        }
        default:
            break;
    }
#endif
}

@implementation PTKAutomateOnboarding

SHARED_INSTANCE(PTKAutomateOnboarding)

-(void)doStuff:(UIView*)sender{
    PTKAutomateOnboardingHandleOnboardState();
}

@end
