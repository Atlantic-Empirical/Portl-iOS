//
//  PTKGuideCameraViewController+View.h
//  portkey
//
//  Created by Robert Reeves on 5/1/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKGuideCameraViewController.h"

@interface PTKGuideCameraViewController (View)


/**
 loads user controls into camera UI, including buttons & labels
 */
- (void)setupView;
- (void)loadUserControls;
- (void)resetControls;

/**
 swipe down to dismiss & pinch to zoom camera gestures
 */
- (void)setupGestures;



/**
 animate UI between video or photo focused controls & timers
 @param BOOL YES for video, NO for photo
 */
- (void)animateViewForVideo:(BOOL)withTimer;

/**
 rolls a ball-shaped send button into view from off right-screen
 */
- (void)animateVideoSubmitButtonIntoView;

/**
 animate rotating marching ants around the capture button, used to convey record state
 */
- (void)beginCircleRotationAnimation;

/**
 present pre-loaded camera onto screen
 */
- (void)animateCameraIntoView;

/**
 update the view for user video capture
 */
- (void)updateViewForVideo;


@end
