//
//  PTKLiveCameraButton.h
//  portkey
//
//  Created by Robert Reeves on 8/15/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PTKLiveCameraButton;
@protocol PTKLiveCameraButtonDelegate <NSObject>

- (void)userDidTapLiveCameraButton:(PTKLiveCameraButton *)cameraButton;

@end

@interface PTKLiveCameraButton : UIView

- (void)animateLiveState:(BOOL)isNowLive;

@property (nonatomic, weak) id<PTKLiveCameraButtonDelegate> delegate;
@property (assign) BOOL liveViewEnabled;
@property (assign) BOOL enabled;

@property (nonatomic) BOOL canControlStage;

@end
