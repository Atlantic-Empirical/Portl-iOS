//
//  PTKCameraZoomViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 26/8/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@class PTKCameraZoomViewController;
@protocol PTKCameraZoomViewControllerDelegate <NSObject>

@required
- (CGRect)cameraZoom:(PTKCameraZoomViewController *)cameraZoom frameForUserId:(NSString *)userId;
- (void)cameraZoomShouldDismiss:(PTKCameraZoomViewController *)cameraZoom;

@end

@interface PTKCameraZoomViewController : PTKBaseViewController

@property (nonatomic, strong) UIView *cameraView;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, weak) id<PTKCameraZoomViewControllerDelegate> delegate;

- (void)showOverlayWithAutoFade:(BOOL)autoFade;
- (void)hideOverlay;

@end
