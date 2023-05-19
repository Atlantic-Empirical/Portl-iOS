//
//  PTKCameraPreview.h
//  portkey
//
//  Created by Rodrigo Sieiro on 11/6/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface PTKCameraPreview : UIView

@property (atomic) AVCaptureSession *session;
@property (atomic) NSString *videoGravity;

@end
