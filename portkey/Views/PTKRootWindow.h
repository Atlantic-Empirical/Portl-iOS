//
//  PTKRootWindow.h
//  portkey
//
//  Created by Daniel Amitay on 4/20/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PTKRootWindowStateUnknown,
    PTKRootWindowStateOutdated,
    PTKRootWindowStateOnboarding,
    PTKRootWindowStateLoggedIn
} PTKRootWindowState;


@interface PTKRootWindow : UIWindow <ABKInAppMessageControllerDelegate>

@property (nonatomic, assign) BOOL idle;
@property (nonatomic, readonly) PTKRootWindowState windowState;

@end
