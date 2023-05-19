//
//  PTKGuideCameraViewController+Actions.m
//  portkey
//
//  Created by Robert Reeves on 5/1/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKGuideCameraViewController+Actions.h"
#import "PTKGuideCameraViewController+View.h"
#import "PTKGuideCameraViewController+Camera.h"

@interface PTKGuideCameraViewController () <AVCaptureFileOutputRecordingDelegate>

@end

@implementation PTKGuideCameraViewController (Actions)


#pragma mark - user interactions

- (void)releaseCaptureButton {
    
        self.isFingerDown = NO;
    
        if (self.movieFileOutput.isRecording) {
            [self.movieFileOutput stopRecording];
        } else {
            if (self.redoButton.hidden == YES) {
                self.captureButton.enabled = NO;
                [self captureButtonTapped];
            }
        }
        
        if (self.isRecording == YES) {
            self.isRecording = NO;
            self.capturingVideo = NO;
            [self startOrStopTorchForVideo];
            [self endRecordingAnimation];
        }
    
}

- (void)touchDownCaptureButton {
    if (!self.captureButton.enabled) return;
    
    self.isFingerDown = YES;
    
    __weak __typeof__(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(350 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        __strong __typeof__(self) strongSelf = weakSelf;
        
        if (!strongSelf.isFingerDown)
            return;
        
        [strongSelf startVideoTimer];
        [strongSelf updateViewForVideo];
        
        if (strongSelf.isRecording) {
            [strongSelf.movieFileOutput startRecordingToOutputFileURL:[strongSelf tempFileURL] recordingDelegate:self];
        } else {
            strongSelf.captureButton.enabled = YES;
        }
    });
    
}

- (void)captureButtonTapped {
    // if the user has started recording videos, we want to take mini-'video snapshots' when they quickly tap the record button
    // otherwise, follow the normal photo capture flow
    if (self.currentSelection == PTKSelectedCameraVideo) {
        self.captureButton.enabled = NO;
        self.isRecording = YES;
        
        [self.movieFileOutput startRecordingToOutputFileURL:[self tempFileURL] recordingDelegate:self];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(200.0 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            self.isRecording = NO;
            [self.movieFileOutput stopRecording];
        });
    } else {
        self.currentSelection = PTKSelectedCameraPhoto;
        [self captureImageAndPost];
    }
}

- (void)pannedDuringCapture:(UIPanGestureRecognizer*)pan {
    if (!self.isFingerDown) return;

    const CGFloat panZoomScaleFactor = 1250.0f;
    
    
    
    if (pan.state == UIGestureRecognizerStateChanged) {
        NSError *error = nil;
        
        if ([self.videoDevice respondsToSelector:@selector(setVideoZoomFactor:)]) {
            if ([self.videoDevice lockForConfiguration:&error]) {
                if (!error) {
                    
                    CGFloat panVelocity = - [pan velocityInView:pan.view].y;
                    CGFloat newFactor = self.videoDevice.videoZoomFactor + (CGFloat)atan(panVelocity / panZoomScaleFactor);
                    
                    if (newFactor > self.videoDevice.activeFormat.videoZoomFactorUpscaleThreshold)
                        newFactor = self.videoDevice.activeFormat.videoZoomFactorUpscaleThreshold;
                    
                    self.videoDevice.videoZoomFactor = (newFactor > 8.0f) ? 8.0f : (newFactor < 1.0f) ? 1.0f : self.videoDevice.videoZoomFactor + (CGFloat)atan(panVelocity / panZoomScaleFactor);
                    
                    [self.videoDevice unlockForConfiguration];
                }
                else {
                    PTKLogError(@"error: %@", error);
                }
            } else {
                PTKLogError(@"error: %@", error);
            }
        }
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        [self releaseCaptureButton];
    }
    
}

- (void)focusCameraOnPointWithTap:(UITapGestureRecognizer*)tap {
    
    CGPoint aPoint = [tap locationOfTouch:0 inView:self.cameraFlipView];
    
    if([self.videoDevice isFocusPointOfInterestSupported] &&
       [self.videoDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        CGPoint focusPoint = [self.previewLayer captureDevicePointOfInterestForPoint:aPoint];
        if([self.videoDevice lockForConfiguration:nil]) {
            [self.videoDevice setFocusPointOfInterest:CGPointMake(focusPoint.x,focusPoint.y)];
            [self.videoDevice setFocusMode:AVCaptureFocusModeAutoFocus];
            [self.videoDevice unlockForConfiguration];
        }
    }
}

- (void)handlePinchToZoomRecognizer:(UIPinchGestureRecognizer*)pinchRecognizer {
    if (self.isFingerDown) return;
    
    const CGFloat pinchZoomScaleFactor = 15.0f;
    
    if (pinchRecognizer.state == UIGestureRecognizerStateChanged) {
        NSError *error = nil;
        
        if ([self.videoDevice respondsToSelector:@selector(setVideoZoomFactor:)]) {
            if ([self.videoDevice lockForConfiguration:&error]) {
                if (!error) {
                    
                    CGFloat newFactor = self.videoDevice.videoZoomFactor + (CGFloat)atan(pinchRecognizer.velocity / pinchZoomScaleFactor);
                    
                    if (newFactor > self.videoDevice.activeFormat.videoZoomFactorUpscaleThreshold)
                        newFactor = self.videoDevice.activeFormat.videoZoomFactorUpscaleThreshold;
                    
                    self.videoDevice.videoZoomFactor = (newFactor > 8.0f) ? 8.0f : (newFactor < 1.0f) ? 1.0f : self.videoDevice.videoZoomFactor + (CGFloat)atan(pinchRecognizer.velocity / pinchZoomScaleFactor);
                    
                    [self.videoDevice unlockForConfiguration];
                }
                else {
                    PTKLogError(@"error: %@", error);
                }
            } else {
                PTKLogError(@"error: %@", error);
            }
        }
    }
}

- (void)flashButtonTapped {
    
    [self.flashButton setSelected:!self.flashButton.selected];
    
    if ([self.videoDevice hasTorch] && [self.videoDevice hasFlash]){
        
        [self.videoDevice lockForConfiguration:nil];
        if (self.flashButton.selected) {
            [self.videoDevice setFlashMode:AVCaptureFlashModeOn];
        } else {
            [self.videoDevice setFlashMode:AVCaptureFlashModeOff];
        }
        [self.videoDevice unlockForConfiguration];
    }
}

- (void)userDidTapFlipCamera {
    
    [PTKEventTracker track:PTKEventTypeCameraFlipped];
    
    [self.captureSession beginConfiguration];
    
    [self.captureSession removeInput:self.videoInput];
    
    AVCaptureDevice *camera = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        NSInteger desiredCamera = (self.facingFront) ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
        if ([device position] == desiredCamera) {
            camera = device;
            break;
        }
    }
    
    NSError *error = nil;
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
    
    self.facingFront = (self.facingFront) ? NO : YES;
    
    // if flash is enabled, turn it off for rear-cam
    if (self.flashButton.isSelected && self.facingFront)
        [self flashButtonTapped];
    
    if ([self.captureSession canAddInput:self.videoInput]) {
        [self.captureSession addInput:self.videoInput];
    }
    
    [self.captureSession commitConfiguration];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.flashButton.alpha = (self.facingFront) ? 0 : 1;
    }];
}

- (void)cancelAction {
    [self.delegate cameraViewControllerDidDismissCamera:self];
}

#pragma mark -

- (void)startOrStopTorchForVideo {
    if (self.flashButton.selected) {
        if ([self.videoDevice hasTorch]){
            [self.videoDevice lockForConfiguration:nil];
            [self.videoDevice setTorchMode:AVCaptureTorchModeOn];
            [self.videoDevice unlockForConfiguration];
        }
    } else {
        [self stopTorch];
    }
}

- (void)stopTorch {
    if ([self.videoDevice hasTorch]){
        [self.videoDevice lockForConfiguration:nil];
        [self.videoDevice setTorchMode:AVCaptureTorchModeOff];
        [self.videoDevice unlockForConfiguration];
    }
}



#pragma mark - record video, storage, timer, label & animations

- (void)startVideoTimer {
    
    if (self.submitImageView != nil) {
        [self.submitImageView removeFromSuperview];
        self.submitImageView = nil;
    }
    
    self.videoTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                       target:self
                                                     selector:@selector(updateTimerLabel:)
                                                     userInfo:nil
                                                      repeats:YES];
    

    PTKRoom *room = [[PTKWeakSharingManager roomsDataSource] objectWithId:self.roomId];
    self.labelTimer.textColor = room.roomColor;
}

- (NSString *)formattedTime:(double)totalSeconds {
    int seconds = (int)totalSeconds % 60;
    int minutes = (int)(totalSeconds / 60) % 60;
    return [NSString stringWithFormat:@"%01d:%02d", minutes, seconds];
}

- (void)updateTimerLabel:(NSTimer*)timer {
    self.labelTimer.text = [self formattedTime:self.totalSeconds + CMTimeGetSeconds(self.movieFileOutput.recordedDuration)];
}

- (NSURL*)tempFileURL {
    // temporary placement of recording video for upload
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), [NSString stringWithFormat:@"%@.mov", [[NSProcessInfo processInfo] globallyUniqueString]]];
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *manager = [[NSFileManager alloc] init];
    if ([manager fileExistsAtPath:outputPath]) {
        [manager removeItemAtPath:outputPath error:nil];
    }
    
    return outputURL;
}

- (void)beginRecordingAnimation {
    [self.captureButton setImage:[PTKGraphics circleImageWithColor:[[PTKColor almostWhiteColor] colorWithAlphaComponent:0.5] andBackground:nil ofDiameter:55.0f] forState:UIControlStateNormal];
    [self beginCircleRotationAnimation];
    if ([self.delegate respondsToSelector:@selector(cameraViewControllerDidStartRecording:)]) {
        [self.delegate cameraViewControllerDidStartRecording:self];
    }
    self.redoButton.hidden = YES;
}

- (void)endRecordingAnimation {
    [self.captureButton setImage:[PTKGraphics circleImageWithColor:[[PTKColor almostWhiteColor] colorWithAlphaComponent:0.5] andBackground:nil ofDiameter:55.0f] forState:UIControlStateNormal];
    
    [self.composingIndicator.layer removeAllAnimations];
    self.composingIndicator.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(cameraViewControllerDidEndRecording:)]) {
        [self.delegate cameraViewControllerDidEndRecording:self];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if ([self.delegate respondsToSelector:@selector(cameraViewControllerDidDisappear:)]) {
        [self.delegate cameraViewControllerDidDisappear:self];
    }
    
    [self redo];
}

-(void)redo {
    [self.videoAssets removeAllObjects];
    self.labelTimer.text = @"";
    self.imagePreviewLayer.image = nil;
    self.imagePreviewLayer.hidden = YES;
    self.flipCameraButton.hidden = NO;
    self.flashButton.alpha = 1;
    self.flashButton.hidden = NO;
    self.totalSeconds = 0;
    [self.videoTimer invalidate];
    self.currentSelection = PTKSelectedCameraPhoto;
    self.redoButton.hidden = YES;
    [self.submitImageView removeFromSuperview];
    self.submitImageView = nil;
    self.captureButton.hidden = NO;
    self.captureButton.enabled = YES;
    self.previewLayer.hidden = NO;
    
    if ([self.delegate respondsToSelector:@selector(cameraViewControllerDidReset:)]) {
        [self.delegate cameraViewControllerDidReset:self];
    }
    
}


@end


