//
//  PTKEmailPickerViewController.m
//  portkey
//
//  Created by Robert Reeves on 1/21/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKEmailPickerViewController.h"
#import "portkey-Swift.h"
#import "PTKActivityViewController.h"


@interface PTKEmailPickerViewController () <UITextFieldDelegate> {
    UILabel *_aboveLabel;
    UITextField *_emailTextField;
    UIView *_emailContainer;
    UILabel *_belowLabel;
    UIButton *_verifyButton;
    UIButton *_resendButton;
    
    PTKSession *_session;

    BOOL _isFetching;
    BOOL _emailTextFieldHasValidUsername;
    BOOL _waitingForVerification;
}

@property (assign) BOOL isPrimaryVerified;
@property (nonatomic) NSString* primaryEmailText;

@property (assign) PTKAccountUpdatePickerType pickerType;

@end



@implementation PTKEmailPickerViewController


#pragma mark - 


- (instancetype)init {
    
    self = [self initWithControllerType:PTKAccountUpdatePickerTypeEmail];
    if (!self) return nil;
    
    return self;
}

- (instancetype)initWithControllerType:(PTKAccountUpdatePickerType)pickerType {
    
    self = [super init];
    if (!self) return nil;
    
    _pickerType = pickerType;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _session = [PTKData sharedInstance].session;
    _waitingForVerification = NO;
    
    self.title = (_pickerType == PTKAccountUpdatePickerTypeEmail) ? localizedString(@"Email") : localizedString(@"Edit Username");
    
    self.view.backgroundColor = [PTKColor almostWhiteColor];
    
    _aboveLabel = [[UILabel alloc] init];
    _aboveLabel.textColor = [UIColor darkGrayColor];
    _aboveLabel.font = [PTKFont regularFontOfSize:12.0f];
    _aboveLabel.backgroundColor = [UIColor clearColor];
    _aboveLabel.textAlignment = NSTextAlignmentCenter;
    _aboveLabel.frame = (CGRect) {
        .origin.x = 20.0f,
        .origin.y = 10.0f,
        .size.width = self.view.width - 40.0f,
        .size.height = 40.f
    };
    _aboveLabel.numberOfLines = 0;
    [self.view addSubview:_aboveLabel];
    
    _emailContainer = [[UIView alloc] init];
    _emailContainer.backgroundColor = [UIColor whiteColor];
    _emailContainer.frame = (CGRect) {
        .origin.x = 0.0f,
        .origin.y = 60.0f,
        .size.width = self.view.width,
        .size.height = 44.0f
    };
    [self.view addSubview:_emailContainer];
    
    _emailTextField = [[UITextField alloc] init];
    _emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailTextField.text = [[PTKData sharedInstance].session primaryEmail];
    _emailTextField.font = [PTKFont regularFontOfSize:(_pickerType == PTKAccountUpdatePickerTypeEmail) ? 17.0f : 15.0f];
    _emailTextField.backgroundColor = [UIColor whiteColor];
    _emailTextField.textColor = [UIColor darkTextColor];
    _emailTextField.rightViewMode = UITextFieldViewModeAlways;
    _emailTextField.frame = (CGRect) {
        .origin.x = 20.0f,
        .origin.y = 0.0f,
        .size.width = self.view.width - 40.0f,
        .size.height = 44.0f
    };
    _emailTextField.delegate = self;
    [_emailTextField addTarget:self action:@selector(emailTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [_emailContainer addSubview:_emailTextField];
    
    [_emailContainer addTopSeparatorWithColor:[PTKColor settingsSeparatorColor]];
    [_emailContainer addBottomSeparatorWithColor:[PTKColor settingsSeparatorColor]];
    
    [self giveEmailTextFieldCorrectRightView];
    
    _belowLabel = [[UILabel alloc] init];
    _belowLabel.textColor = [UIColor darkGrayColor];
    _belowLabel.font = [PTKFont regularFontOfSize:12.0f];
    _belowLabel.backgroundColor = [UIColor clearColor];
    _belowLabel.textAlignment = NSTextAlignmentCenter;
    _belowLabel.frame = (CGRect) {
        .origin.x = 10.0f,
        .origin.y = 114.0f,
        .size.width = self.view.width - 20.0f,
        .size.height = 40.f
    };
    _belowLabel.numberOfLines = 0;
    [self.view addSubview:_belowLabel];
    
    _verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verifyButton addTarget:self action:@selector(verifyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_verifyButton setTitle:(_pickerType == PTKAccountUpdatePickerTypeEmail) ? localizedString(@"CONTINUE") : localizedString(@"CONFIRM CHANGE") forState:UIControlStateNormal];
    [_verifyButton setTitleColor:[PTKColor almostWhiteColor] forState:UIControlStateNormal];
    _verifyButton.titleLabel.font = [PTKFont regularFontOfSize:17.0f];
    _verifyButton.backgroundColor = [PTKColor brandColor];
    _verifyButton.showsTouchWhenHighlighted = YES;
    _verifyButton.frame = (CGRect) {
        .origin.x = 0.0f,
        .origin.y = self.view.bounds.size.height,
        .size.width = self.view.width,
        .size.height = 60.0f
    };
    _verifyButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_verifyButton];
    
    _resendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resendButton addTarget:self action:@selector(verifyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_resendButton setTitle:localizedString(@"Resend verification email") forState:UIControlStateNormal];
    [_resendButton setTitleColor:[PTKColor brandColor] forState:UIControlStateNormal];
    _resendButton.titleLabel.font = [PTKFont regularFontOfSize:12.0f];
    _resendButton.frame = (CGRect) {
        .size = [_resendButton.titleLabel sizeThatFits:self.view.bounds.size]
    };
    _resendButton.center = _belowLabel.center;
    [self.view addSubview:_resendButton];
    
    [self configureFromCurrentEmail];
    
    [self listenFor:kNotificationAppWillEnterForeground selector:@selector(appForegrounded)];
    
    if (_presentedByInterstitial) {
        UIBarButtonItem* back = [[UIBarButtonItem alloc] initWithImage:[PTKGraphics navigationBackImageWithColor:nil] style:UIBarButtonItemStyleDone target:self action:@selector(didTapBackButton)];
        self.navigationItem.leftBarButtonItem = back;
    }
    
    if (_pickerType == PTKAccountUpdatePickerTypeUsername) {
        _aboveLabel.text = localizedString(@"People can search for you by username");
    }
}

- (void)didTapBackButton {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)layoutForKeyboard {
    
    CGFloat heightBuffer = 0;
    BOOL shouldShowButton = NO;
    if (_pickerType == PTKAccountUpdatePickerTypeUsername) {
        if (_emailTextField.isFirstResponder && _emailTextFieldHasValidUsername)
            shouldShowButton = YES;
    }
    else {
        shouldShowButton = YES;
    }
    
    if (shouldShowButton)
        heightBuffer = 60.0f;
    
    _verifyButton.frame = (CGRect) {
        .origin.x = 0.0f,
        .origin.y = self.view.bounds.size.height - self.keyboardHeight - self.bottomLayoutGuide.length - heightBuffer,
        .size.width = self.view.width,
        .size.height = 60.0f
    };
}

- (void)appForegrounded {
    // update app session list of primary/secondary emails from the server
    PTKAPICallback *userCallback = [PTKAPI callbackWithTarget:self selector:@selector(onDidFetchUser:)];
    [PTKAPI fetchUserWithCallback:userCallback];
}


#pragma mark -

- (void)configureFromCurrentEmail {
    
    
    switch (_pickerType) {
        case PTKAccountUpdatePickerTypeEmail: {
            
            _emailTextField.text = [_session primaryEmail];
            
            if ([_session primaryEmailIsVerified]) {
                _aboveLabel.text = localizedString(@"Your email address is used to log in and secure your Airtime account.");
                _belowLabel.text = localizedString(@"Your email address is verified! 👍");
                _verifyButton.hidden = YES;
                _resendButton.hidden = YES;
                [self giveRightViewThumbsUp];
            }
            else {
                _aboveLabel.text = localizedString(@"Please verify your email address. Your email address is used to log in and secure your Airtime account.");
                _belowLabel.text = localizedString(@"");
                _verifyButton.hidden = NO;
                _resendButton.hidden = NO;
                _emailTextField.rightView = nil;
            }
        }
            break;
            
        case PTKAccountUpdatePickerTypeUsername: {
            
            _emailTextField.text = [NSString stringWithFormat:@"@%@", [PTKData sharedInstance].session.username];
            
            _resendButton.hidden = YES;
        }
            break;
            
        default: {
            
        }
            break;
    }
}

- (void)updateStateFromVerificationStatus {
    NSString *email = _emailTextField.text;
    
    if ([[_session primaryEmail] isEqualToString:email] && [_session hasEmail:email] && [_session emailIsVerified:email]) {
        _aboveLabel.text = localizedString(@"Your email address is used to log in and secure your Airtime account.");
        _belowLabel.text = localizedString(@"Your email address is verified! 👍");
        _belowLabel.textColor = [UIColor darkGrayColor];
        _verifyButton.hidden = YES;
        _resendButton.hidden = YES;
        [self giveRightViewThumbsUp];
    }
    else if (_waitingForVerification) {
        _aboveLabel.text = localizedString(@"We've sent a verification email to you. Please open the link to finish verifying your address.");
        _belowLabel.text = localizedString(@"");
        _verifyButton.hidden = YES;
        _resendButton.hidden = NO;
        _emailTextField.rightView = nil;
    }
    else {
        _aboveLabel.text = localizedString(@"Please verify your email address. Your email address is used to log in and secure your Airtime account.");
        _belowLabel.text = localizedString(@"");
        _belowLabel.textColor = [UIColor darkGrayColor];
        _verifyButton.hidden = NO;
        _resendButton.hidden = YES;
        _emailTextField.rightView = nil;
    }
}

- (void)showError:(NSString *)error {
    _emailContainer.backgroundColor = [PTKColor redActionColor];
    _emailTextField.backgroundColor = [PTKColor redActionColor];
    _emailTextField.textColor = [PTKColor almostWhiteColor];
    _belowLabel.backgroundColor = [PTKColor redActionColor];
    _belowLabel.textColor = [PTKColor almostWhiteColor];
    
    _belowLabel.text = error;
    _emailContainer.frame = (CGRect) {
        .origin.x = 0.0f,
        .origin.y = 60.0f,
        .size.width = self.view.width,
        .size.height = 94.0f
    };
    
    [_emailTextField becomeFirstResponder];
}

- (void)hideError {
    _emailContainer.backgroundColor = [PTKColor almostWhiteColor];
    _emailTextField.backgroundColor = [PTKColor almostWhiteColor];
    _emailTextField.textColor = [UIColor darkTextColor];
    _belowLabel.backgroundColor = [UIColor clearColor];
    _belowLabel.textColor = [UIColor darkGrayColor];
    
    _emailContainer.frame = (CGRect) {
        .origin.x = 0.0f,
        .origin.y = 60.0f,
        .size.width = self.view.width,
        .size.height = 44.0f
    };
    
    [self updateStateFromVerificationStatus];
}


#pragma mark - action methods

- (void)emailTextFieldChanged {
    
    
    switch (_pickerType) {
        case PTKAccountUpdatePickerTypeEmail: {
            
            _waitingForVerification = NO;
            [UIView animateWithDuration:0.1f animations:^(){
                [self hideError];
                [self updateStateFromVerificationStatus];
                [self giveEmailTextFieldCorrectRightView];
            }];
        }
            break;
            
        case PTKAccountUpdatePickerTypeUsername: {
            
            _emailTextField.text = [NSString stringWithFormat:@"@%@", [_emailTextField.text stringByReplacingOccurrencesOfString:@"@" withString:@""]];
            
            _isFetching = YES;
            
            PTKAPICallback *fetchCallback = [PTKAPI callbackWithTarget:self selector:@selector(userNameAvailabilityDidReturn:)];
            [PTKAPI fetchUserNameAvailability:[_emailTextField.text stringByReplacingOccurrencesOfString:@"@" withString:@""] withCallback:fetchCallback];
        }
            break;
            
        default:
            break;
    }
}

- (void)userNameAvailabilityDidReturn:(PTKAPIResponse*)response {
    
    _isFetching = NO;
    
    if (response.error) {
        
        UILabel* rightLabel = [[UILabel alloc] init];
        rightLabel.textColor = [PTKColor grayColor];
        rightLabel.font = [PTKFont regularFontOfSize:12.0f];
        _emailTextField.rightView = rightLabel;
        
        _emailTextFieldHasValidUsername = NO;
        
        if (_emailTextField.text.length <= 3) {
            _aboveLabel.text = localizedString(@"Usernames must be at least 3 characters");
        }
        else if (_emailTextField.text.length >= 30) {
            _aboveLabel.text = localizedString(@"Usernames can only be 30 characters");
        }
        else if (response.error.code == PTKErrorCodeMalformedInput) {
            _aboveLabel.text = localizedString(@"Only letters, numbers, \".\", and \"_\" are allowed");
        }
        else {
            _aboveLabel.text = localizedString(@"Username not available 😢");
        }
        [rightLabel sizeToFit];
    }
    else {
        
        _aboveLabel.text = @"";
        
        _emailTextFieldHasValidUsername = YES;
        
        [self giveRightViewThumbsUp];
    }
    
    [self layoutForKeyboard];
}

- (void)verifyButtonPressed {
    
    switch (_pickerType) {
        case PTKAccountUpdatePickerTypeUsername: {
            
            PTKAPICallback *callback = [[PTKAPICallback alloc] initWithTarget:self selector:@selector(onDidChangeUsername:) userInfo:nil];
            [PTKAPI updateUserUsername:[_emailTextField.text stringByReplacingOccurrencesOfString:@"@" withString:@""] withCallback:callback];
        }
            break;
        
        case PTKAccountUpdatePickerTypeEmail: {
            
            NSString *email = [_emailTextField.text stringByTrimmingWhiteSpace];
            
            if (email.isValidEmail) {
                [_emailTextField resignFirstResponder];
                
                if (![_session hasEmail:email]) {
                    PTKAPICallback *callback = [[PTKAPICallback alloc] initWithTarget:self selector:@selector(onDidChangePrimaryEmail:) userInfo:@{@"didVerify":@(YES), @"email":email}];
                    [PTKAPI addEmailToUserAccountWithEmail:email asPrimary:YES callback:callback];
                }
                else if (![[_session primaryEmail] isEqualToString:email]) {
                    BOOL shouldVerify = ![_session emailIsVerified:email];
                    
                    PTKAPICallback *callback = [[PTKAPICallback alloc] initWithTarget:self selector:@selector(onDidChangePrimaryEmail:) userInfo:@{@"shouldVerify":@(shouldVerify), @"email":email}];
                    [PTKAPI changeUserPrimaryEmail:email callback:callback];
                }
                else {
                    PTKAPICallback *callback = [[PTKAPICallback alloc] initWithTarget:self selector:@selector(onDidVerifyEmail:) userInfo:@{@"email":email}];
                    [PTKAPI verifyUserWithEmail:email callback:callback];
                }
            }
            else {
                [self showError:localizedString(@"Please enter a valid email address.")];
            }
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (_emailTextFieldHasValidUsername) {
        
        [textField resignFirstResponder];
        [self verifyButtonPressed];
        
        return YES;
    }
    else {
        return NO;
    }
}


#pragma mark - api response

- (void)onDidFetchUser:(PTKAPIResponse *)response {
    if (response.error) {
        PTKLogDebug(@"%@", response.error.localizedDescription);
        return;
    }
    else {
        
        PTKSession *session = [[PTKSession alloc] initWithJSON:response.JSON];
        if (session) {
            [PTKData sharedInstance].session = session;
        }
        
        _session = session;
        
        if (_pickerType == PTKAccountUpdatePickerTypeEmail) {
            
            [UIView animateWithDuration:0.1f animations:^(){
                [self updateStateFromVerificationStatus];
            }];   
        }
        else {
            
            NSMutableParagraphStyle *attributedStringParagraphStyle = [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
            attributedStringParagraphStyle.alignment = NSTextAlignmentCenter;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:localizedString(@"You claimed one of the best usernames on Airtime! Show it off and share it with your friends")];
            [attributedString addAttribute:NSFontAttributeName value:[PTKFont regularFontOfSize:16.0f] range:NSMakeRange(0 ,attributedString.length)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[PTKColor grayColor] range:NSMakeRange(0 ,attributedString.length)];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:attributedStringParagraphStyle range:NSMakeRange(0 ,attributedString.length)];
            PTKAlertViewController *alert = [[PTKAlertViewController alloc] initWithTitle:[NSString stringWithFormat:localizedString(@"Congratulations @%@!"), _session.username] attributedDescription:attributedString emoji:@"🎉"];
            PTKAlertAction *skip = [[PTKAlertAction alloc] initWithTitle:localizedString(@"Not now") style:UIAlertActionStyleCancel handler: ^{
                
                [alert dismiss];
            }];
            PTKAlertAction *claim = [[PTKAlertAction alloc] initWithTitle:localizedString(@"Share") style:UIAlertActionStyleDefault handler: ^{
                
                [alert dismiss];
                
                NSString *inviteText = [PTKCopyHelper appInviteText];
                
                PTKActivityViewController *activityController = [[PTKActivityViewController alloc] initWithActivityItems:@[inviteText] applicationActivities:nil];
                [activityController setValue:localizedString(@"Join me on Airtime!") forKey:@"Subject"];
                activityController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
                    
                    NSMutableDictionary* props = [NSMutableDictionary dictionaryWithCapacity:4];
                    [props safeSetObject:activityType forKey:@"shareTarget"];
                    [props safeSetObject:@"usernamePicker" forKey:@"appLocation"];
                    [props safeSetObject:@"profile" forKey:@"shareType"]; 
                    if (!completed)
                        [props safeSetObject:(!NILORNULL(activityError) ? @"error" : @"cancelled") forKey:@"cause"];
                    
                    [PTKEventTracker track:(completed) ? PTKEventTypeGraphURLShared : PTKEventTypePeopleTabUrlShareFailed
                            withProperties:props];
                };
                [self presentViewController:activityController animated:YES completion:nil];
            }];
            alert.actions = @[skip, claim];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (void)onDidChangePrimaryEmail:(PTKAPIResponse*)response {
    if (response.error) {
        
        if ([response.error isError:PTKErrorCodeDuplicateEmail]) {
            [self showError:localizedString(@"That email is already associated with an account.")];
        }
        else if ([response.error isError:PTKErrorCodeMalformedInput]) {
            [self showError:localizedString(@"Please enter a valid email address.")];
        }
        else {
            [self showError:localizedString(@"Something went wrong. Please try again.")];
        }
        
        PTKLogDebug(@"%@", response.error.localizedDescription);
        return;
    }
    else {
        if ([response.userInfo[@"shouldVerify"] boolValue] && response.userInfo[@"email"]) {
            PTKAPICallback *callback = [[PTKAPICallback alloc] initWithTarget:self selector:@selector(onDidVerifyEmail:) userInfo:@{@"email":response.userInfo[@"email"]}];
            [PTKAPI verifyUserWithEmail:response.userInfo[@"email"] callback:callback];
        }
        else if ([response.userInfo[@"didVerify"] boolValue]) {
            [self updateSessionAndShowVerifiedAlert:response.userInfo[@"email"]];
        }
        else {
            // update app session list of primary/secondary emails from the server
            PTKAPICallback *userCallback = [PTKAPI callbackWithTarget:self selector:@selector(onDidFetchUser:)];
            [PTKAPI fetchUserWithCallback:userCallback];
        }
    }
}

- (void)onDidChangeUsername:(PTKAPIResponse*)response {
    
    if (response.error) {
        
        if (response.error) {
            [self showError:localizedString(@"There was a problem udpating your username. Please try again.")];
            
            PTKLogDebug(@"%@", response.error.localizedDescription);
            return;
        }
    }
    else {
        
        [self giveRightViewThumbsUp];
        
        [_emailTextField resignFirstResponder];
        [self layoutForKeyboard];
        
        PTKAPICallback *userCallback = [PTKAPI callbackWithTarget:self selector:@selector(onDidFetchUser:)];
        [PTKAPI fetchUserWithCallback:userCallback];
    }
}

- (void)onDidVerifyEmail:(PTKAPIResponse*)response {
    
    if (response.error) {
        [self showError:localizedString(@"There was a problem sending a verification email. Please try again.")];

        PTKLogDebug(@"%@", response.error.localizedDescription);
        return;
    }
    
    _waitingForVerification = YES;
    [UIView animateWithDuration:0.1f animations:^(){
        [self updateStateFromVerificationStatus];
    }];
    
    [self updateSessionAndShowVerifiedAlert:response.userInfo[@"email"]];
}

- (void)updateSessionAndShowVerifiedAlert:(NSString *)email {
    PTKAlertController *alertView = [PTKAlertController alertControllerWithTitle:NSLocalizedString(@"Check your email!", 0) message:[NSString stringWithFormat:NSLocalizedString(@"We've sent a verification email to %@", 0), email]];
    [alertView addButtonWithTitle:localizedString(@"OK") block:nil];
    [self presentViewController:alertView animated:YES completion:nil];
    
    // update app session list of primary/secondary emails from the server
    PTKAPICallback *userCallback = [PTKAPI callbackWithTarget:self selector:@selector(onDidFetchUser:)];
    [PTKAPI fetchUserWithCallback:userCallback];
}


#pragma mark - 

- (void)giveEmailTextFieldCorrectRightView {
    NSString *email = _emailTextField.text;
    
    if (!NILORNULL(_emailTextField.rightView)) {
        _emailTextField.rightView = nil;
    }
    
    
    if ([[_session primaryEmail] isEqualToString:email] && [_session hasEmail:email] && [_session emailIsVerified:email]){
        
        [self giveRightViewThumbsUp];
    }
    else if (_isFetching) {
        
        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.tintColor = [UIColor blackColor];
        _emailTextField.rightView = activity;
        [activity startAnimating];
    }
}

- (void)giveRightViewThumbsUp {
    
    UILabel* rightLabel = [[UILabel alloc] init];
    rightLabel.text = @"👍";
    _emailTextField.rightView = rightLabel;
    [rightLabel sizeToFit];
}

@end
