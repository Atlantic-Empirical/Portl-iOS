//
//  PTKGuideCameraViewController+Actions.h
//  portkey
//
//  Created by Robert Reeves on 5/1/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKGuideCameraViewController.h"

@interface PTKGuideCameraViewController (Actions)


/**
 tap on camera button takes a single photo
 */
- (void)captureButtonTapped;

/**
 long press on camera button begins & ends recording video
 */
- (void)touchDownCaptureButton;
- (void)releaseCaptureButton;

/**
 pan while recording zooms in and out
 */
- (void)pannedDuringCapture:(UIPanGestureRecognizer*)pan;

/**
 pinch gesture over camera manages zoom factor
 */
- (void)handlePinchToZoomRecognizer:(UIPinchGestureRecognizer*)pinchRecognizer;

/**
 focus camera on tap position
 */
- (void)focusCameraOnPointWithTap:(UITapGestureRecognizer*)tap;


/**
 flips camera session to the opposite (front / rear) facing camera
 */
- (void)userDidTapFlipCamera;

/**
 each action switches between flash mode ON or OFF
 */
- (void)flashButtonTapped;
- (void)startOrStopTorchForVideo;

/**
 dismiss view controller 
 */
- (void)cancelAction;
- (void)redo;


/**
 video recording timer management & animation
 */
- (void)beginRecordingAnimation;
- (void)endRecordingAnimation;

/**
 turn flash off
 */
- (void)stopTorch;



/**
 video recording, storage and timing
 */
- (NSURL*)tempFileURL;
- (NSString *)formattedTime:(double)totalSeconds;

@end
