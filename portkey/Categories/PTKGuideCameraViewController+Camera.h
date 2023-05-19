//
//  PTKGuideCameraViewController+Camera.h
//  portkey
//
//  Created by Robert Reeves on 5/1/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKGuideCameraViewController.h"

@interface PTKGuideCameraViewController (Camera)


/**
 setup & tear down video capture session and camera preview layer
 */
- (void)setupCamera;
- (void)tearDownCameraInternalWithCompletion:(void(^)())completion;


/**
 capture still camera photo for appropriate orientation, save to photos album & upload
 */
- (void)captureImageAndPost;

/**
 build final video from all user recordings & upload
 */
- (void)compileVideoAssetsAndPost;

- (void)configureVideoOrientation;


@end
