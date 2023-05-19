//
//  PTKBaseViewController.m
//  portkey
//
//  Created by Daniel Amitay on 3/17/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"
#import "PTKLabeledSpinner.h"
#import "PTKNavigationController.h"
#import "portkey-Swift.h"

BOOL OrientationMaskSupportsOrientation(UIInterfaceOrientationMask mask, UIInterfaceOrientation orientation) {
    return (mask & (1 << orientation)) != 0;
}


@interface PTKBaseViewController () {
    CGRect _keyboardViewFrame;
    PTKLabeledSpinner *_spinnerView;
}

@property (nonatomic, readwrite) BOOL viewHasAppeared;
@property (nonatomic, readwrite) BOOL viewIsAppearing;
@property (nonatomic, readwrite) BOOL viewIsVisible;

@property (nonatomic, readwrite) BOOL didJustDismissPresented;

@end

@implementation PTKBaseViewController


#pragma mark - Lifecycle methods

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)shortcutDidMute {
    PTKAlertController *alertController = [PTKAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Airtime has been muted for one hour",0)];
    [alertController addCancelButtonWithTitle:NSLocalizedString(@"OK",0) block:nil];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - View methods

- (void)viewDidLoad {
    [super viewDidLoad];

    // Listen for splash screen finish
    [self listenFor:kNotificationAppDidFinishSplashScreen selector:@selector(onDidFinishSplashScreen)];

    // Register for notifications related to the keyboard
    [self listenFor:UIKeyboardWillShowNotification selector:@selector(keyboardWillBeShown:)];
    [self listenFor:UIKeyboardWillHideNotification selector:@selector(keyboardWillBeHidden:)];
    [self listenFor:UIKeyboardDidShowNotification selector:@selector(keyboardDidShow:)];
    [self listenFor:UIKeyboardDidHideNotification selector:@selector(keyboardDidHide:)];
    [self listenFor:UIKeyboardWillChangeFrameNotification selector:@selector(keyboardWillChangeFrame:)];
    [self listenFor:@"shortcutDidMute" selector:@selector(shortcutDidMute)];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.viewIsAppearing = YES;
    self.didJustDismissPresented = (self.presentedViewController != nil);
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.viewIsAppearing = NO;
    self.viewIsVisible = YES;

    dispatch_async(dispatch_get_main_queue(), ^{
        self.viewHasAppeared = YES;
        self.didJustDismissPresented = NO;
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated endEditing:(BOOL)endEditing {
    [super viewWillDisappear:animated];
    
    if (endEditing) {
        [self.view endEditing:YES];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.view endEditing:YES];
    self.viewIsVisible = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    if (_spinnerView && !_spinnerView.hidden) {
        [self.view bringSubviewToFront:_spinnerView];
    }
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    BOOL changed = !UIEdgeInsetsEqualToEdgeInsets(contentInset, _contentInset);
    _contentInset = contentInset;

    if (changed) [self contentInsetDidChange];
}

#pragma mark - Rotation/status bar methods

- (BOOL)prefersStatusBarHidden {
    return ![PTKAppState sharedInstance].didFinishSplashScreen;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


#pragma mark - Override-able methods

- (void)layoutForKeyboard {
    // NIMP
}

- (void)contentInsetDidChange {
    // NIMP
}


#pragma mark - Convenience methods

- (void)presentViewControllerWithStandardNav:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    PTKNavigationController *nav = [[PTKNavigationController alloc] initWithRootViewController:viewControllerToPresent];
    [self presentViewController:nav animated:flag completion:completion];
}

- (void)dismissAnimated {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    PTKAlertController *alertView = [PTKAlertController alertControllerWithTitle:title message:message];
    [alertView addCancelButtonWithTitle:NSLocalizedString(@"OK",0)];
    [self presentViewController:alertView animated:YES completion:nil];
}


#pragma mark - Loading indicator methods

- (void)showSavingSpinner {
    [self showSpinnerWithTitle:@"Saving..."];
}

- (void)showSpinner {
    [self showSpinnerWithTitle:nil];
}

- (void)showLoadingSpinner {
    [self showSpinnerWithTitle:NSLocalizedString(@"Loading",0)];
}

- (void)showSpinnerWithTitle:(NSString *)title {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_spinnerView) {
            _spinnerView = [[PTKLabeledSpinner alloc] initWithFrame:self.view.bounds];
            _spinnerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [self.view addSubview:_spinnerView];
        } else {
            [self.view bringSubviewToFront:_spinnerView];
        }
        
        _spinnerView.title = title;
        _spinnerView.hidden = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    });
}

- (void)hideSpinner {
    dispatch_async(dispatch_get_main_queue(), ^{
        _spinnerView.hidden = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    });
}

#pragma mark - Keyboard methods

- (BOOL)keyboardIsVisible {
    CGRect intersectionRect = CGRectIntersection(self.view.bounds, self.keyboardFrame);
    return intersectionRect.size.width > 0.0 && intersectionRect.size.height > 0.0;
}

- (CGRect)keyboardFrame {
    if (CGRectEqualToRect(CGRectZero, _keyboardViewFrame)) {
        return (CGRect) {
            .origin.y = self.view.bounds.size.height,
        };
    } else {
        return _keyboardViewFrame;
    }
}

- (CGFloat)keyboardHeight {
    return self.view.bounds.size.height - self.keyboardFrame.origin.y;
}

- (void)adjustLayoutToKeyboardAnimationNotification:(NSNotification *)aNotification {
    CGRect keyboardEndFrameWindow = [[aNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardEndFrameView = [self.view convertRect:keyboardEndFrameWindow fromView:nil];
    double keyboardTransitionDuration = [[aNotification.userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve keyboardTransitionAnimationCurve = [[aNotification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];

    // This has a story behind it.
    // TL;DR; Apple has its own private UIViewAnimationCurves
    // which they do not tell us about but will pass to us in notifications
    UIViewAnimationOptions animationOptions = keyboardTransitionAnimationCurve << 16;
    _keyboardViewFrame = keyboardEndFrameView;
    [UIView animateWithDuration:keyboardTransitionDuration
                          delay:0.0f
                        options:animationOptions | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self layoutForKeyboard];
                     }
                     completion:nil];
}

#pragma mark - Splash screen notification

- (void) onDidFinishSplashScreen {
    [UIView animateWithDuration:0.2f animations:^{
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

#pragma mark - Keyboard Notification Methods

- (void)keyboardDidHide:(NSNotification *)notification {
    if (FirstResponderInView(self.view) || self.monitorKeyboardInOtherViews) {
        [self adjustLayoutToKeyboardAnimationNotification:notification];
    }
}

- (void)keyboardDidShow:(NSNotification *)notification {
    if (FirstResponderInView(self.view) || self.monitorKeyboardInOtherViews) {
        [self adjustLayoutToKeyboardAnimationNotification:notification];
    }
}

- (void)keyboardWillBeShown:(NSNotification *)notification {
    // Hide invite Nudge if it's shown
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNavigationHideNudge object:nil];

    if (FirstResponderInView(self.view) || self.monitorKeyboardInOtherViews) {
        [self adjustLayoutToKeyboardAnimationNotification:notification];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    if (FirstResponderInView(self.view) || self.monitorKeyboardInOtherViews) {
        [self adjustLayoutToKeyboardAnimationNotification:notification];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    if (FirstResponderInView(self.view) || self.monitorKeyboardInOtherViews) {
        [self adjustLayoutToKeyboardAnimationNotification:notification];
    }
}

UIView *FirstResponderInView(UIView *view) {
    if (view.isFirstResponder) {
        return view;
    } else {
        for (UIView *subview in view.subviews) {
            UIView *firstResponderInView = FirstResponderInView(subview);
            if (firstResponderInView) {
                return firstResponderInView;
            }
        }
        return nil;
    }
}

@end
