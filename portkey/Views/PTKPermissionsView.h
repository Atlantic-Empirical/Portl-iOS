//
//  PTKPermissionsView.h
//  portkey
//
//  Created by Daniel Amitay on 3/19/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKPermissionManager.h"

@class PTKPermissionsView;
@protocol PTKPermissionsViewDelegate <NSObject>

@optional
- (void)permissionsView:(PTKPermissionsView *)permissionsView wantsPopupForPermission:(PTKPermissionType)permissionType;
- (void)permissionsViewDidFinish:(PTKPermissionsView *)permissionsView;

@end

@interface PTKPermissionsView : UIView

@property (nonatomic, weak) id <PTKPermissionsViewDelegate> delegate;

+ (BOOL)shouldDisplayPermissionsView;

- (void)evaluateCurrentState;

@end
