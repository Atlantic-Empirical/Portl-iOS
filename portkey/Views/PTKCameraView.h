//
//  PTKCameraView.h
//  portkey
//
//  Created by Daniel Amitay on 5/6/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKStreamBaseView.h"

@class PTKCamera;
@interface PTKCameraView : PTKStreamBaseView

@property (nonatomic, strong, readonly) PTKCamera *camera;
@property (nonatomic) BOOL frozen;

+ (PTKCameraView *)sharedInstance;

- (void)setFrozen:(BOOL)frozen;
- (void)setFrozen:(BOOL)frozen completion:(void(^)())completion;
- (void)updateFrozenImageIfPossible;
- (BOOL)isCameraOn;

- (void)startCapturingStillsWithFPS:(CMTime)fps captureBlock:(void(^)(UIImage *image))captureBlock;
- (void)stopCapturingStills;

@end
