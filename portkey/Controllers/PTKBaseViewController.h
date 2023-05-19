//
//  PTKBaseViewController.h
//  portkey
//
//  Created by Daniel Amitay on 3/17/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

BOOL OrientationMaskSupportsOrientation(UIInterfaceOrientationMask mask, UIInterfaceOrientation orientation);

@interface PTKBaseViewController : UIViewController

@property (nonatomic, readonly) BOOL viewHasAppeared;
@property (nonatomic, readonly) BOOL viewIsAppearing;
@property (nonatomic, readonly) BOOL viewIsVisible;

// Useful for knowing in viewDidAppear: if it was from dismissing a presented modal view
@property (nonatomic, readonly) BOOL didJustDismissPresented;

@property (nonatomic, readonly) BOOL keyboardIsVisible;
@property (nonatomic, readonly) CGRect keyboardFrame;
@property (nonatomic, readonly) CGFloat keyboardHeight;
@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, assign) BOOL monitorKeyboardInOtherViews;

// Override-able methods
- (void)layoutForKeyboard; // Only gets called if the first responder is a descendant of the view
- (void)contentInsetDidChange;

// Convenience methods
- (void)presentViewControllerWithStandardNav:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissAnimated;
- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;

// Loading indicator
- (void)showSpinner;
- (void)showSavingSpinner;
- (void)showLoadingSpinner;
- (void)showSpinnerWithTitle:(NSString *)title;
- (void)hideSpinner;

// custom view methods
- (void)viewWillDisappear:(BOOL)animated endEditing:(BOOL)endEditing;

@end
