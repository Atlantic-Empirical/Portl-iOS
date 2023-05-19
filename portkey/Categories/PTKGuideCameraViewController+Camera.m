//
//  PTKGuideCameraViewController+Camera.m
//  portkey
//
//  Created by Robert Reeves on 5/1/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKGuideCameraViewController+Camera.h"
#import "PTKGuideCameraViewController+Actions.h"
#import "PTKGuideCameraViewController+View.h"
#import <Photos/Photos.h>

@interface PTKGuideCameraViewController () <AVCaptureFileOutputRecordingDelegate>

@end

@implementation PTKGuideCameraViewController (Camera)

#pragma mark -

- (void)setupCamera {
    [self setupCaptureSession];

    UITapGestureRecognizer *tapToFocusRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusCameraOnPointWithTap:)];
    tapToFocusRecognizer.numberOfTapsRequired = 1;
    tapToFocusRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapToFocusRecognizer];

    // Ensure default state of flash disabled
    if ([self.videoDevice isFlashAvailable]) {
        if ([self.videoDevice isFlashModeSupported:AVCaptureFlashModeOff]) {
            [self.videoDevice lockForConfiguration:nil];
            [self.videoDevice setFlashMode:AVCaptureFlashModeOff];
            [self.videoDevice unlockForConfiguration];
        }

        self.flashButton.hidden = NO;
    } else {
        self.flashButton.hidden = YES;
    }

    [self animateCameraIntoView];

    if ([PTKExternalDisplay sharedInstance].isExternalDisplayEnabled) {
        [[PTKExternalDisplay sharedInstance].mirroredScreenView.layer addSublayer:self.previewLayer];
        self.previewLayer.frame = [PTKExternalDisplay sharedInstance].mirroredScreenView.bounds;
    } else {
        [self.cameraFlipView.layer addSublayer:self.previewLayer];
    }    
}

- (void)setupCaptureSession {
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.usesApplicationAudioSession = YES;
    self.captureSession.automaticallyConfiguresApplicationAudioSession = NO;

    // Fallback for old devices
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [self.captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
    } else if ([self.captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [self.captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    } else {
        [self.captureSession setSessionPreset:AVCaptureSessionPresetMedium];
    }

    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.stillImageOutput setOutputSettings:[[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil]];

    if ([self.captureSession canAddOutput:self.stillImageOutput]) {
        [self.captureSession addOutput:self.stillImageOutput];
    }

    self.movieFileOutput = [AVCaptureMovieFileOutput new];

    if([self.captureSession canAddOutput:self.movieFileOutput]) {
        [self.captureSession addOutput:self.movieFileOutput];
    }

    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    if (self.videoDevice) {
        if([self.videoDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            if([self.videoDevice lockForConfiguration:nil]) {
                [self.videoDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                if ([self.videoDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]){
                    [self.videoDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                }
                [self.videoDevice unlockForConfiguration];
            }
        }

        NSError *error = nil;
        self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:&error];

        if (!self.videoInput && error) {
            PTKLogError(@"Camera Initialization Error: %@", error);
        }

        if ([self.captureSession canAddInput:self.videoInput]) {
            [self.captureSession addInput:self.videoInput];
        }

        self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

        self.cameraFlipView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.cameraFlipView.userInteractionEnabled = NO;
        self.cameraFlipView.alpha = 0;
        self.cameraFlipView.exclusiveTouch = NO;
        self.previewLayer.frame = [UIScreen mainScreen].bounds;
        self.defaultCameraRect = self.previewLayer.frame;
    }

    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];

    if (audioCaptureDevice) {
        NSError *error = nil;
        AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];

        if (!audioInput && error) {
            PTKLogError(@"Camera Initialization Error: %@", error);
        }

        if ([self.captureSession canAddInput:audioInput]) {
            [self.captureSession addInput:audioInput];
        }
    }

    [self configureVideoOrientation];
}

- (void)configureVideoOrientation {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.movieFileOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
            break;
    }

    if (videoConnection != nil) {
        AVCaptureVideoOrientation avcaptureOrientation;

        if (_currentOrientation == UIInterfaceOrientationLandscapeRight) {
            avcaptureOrientation  = AVCaptureVideoOrientationLandscapeRight;
        } else if (_currentOrientation == UIInterfaceOrientationLandscapeLeft) {
            avcaptureOrientation  = AVCaptureVideoOrientationLandscapeLeft;
        } else {
            avcaptureOrientation = AVCaptureVideoOrientationPortrait;
        }

        [videoConnection setVideoOrientation:avcaptureOrientation];
    }
}

- (void)tearDownCameraInternalWithCompletion:(void(^)())completion {
    [self.captureSession stopRunning];
    [self.previewLayer removeFromSuperlayer];
    
    for (AVCaptureInput *input in self.captureSession.inputs) {
        [self.captureSession removeInput:input];
    }
    
    for (AVCaptureOutput *output in self.captureSession.outputs) {
        [self.captureSession removeOutput:output];
    }
    
    self.previewLayer.session = nil;
    self.previewLayer = nil;
    self.captureSession = nil;
    
    [[PTKAudio sharedInstance] resignRecordWithCompletion:^(BOOL changed){
        if (completion) completion();
    }];
}


#pragma mark - 

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            self.flipCameraButton.alpha = 0;
        }];
    });
}

- (void)captureImageAndPost {
    AVCaptureConnection *videoConnection = nil;

    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
    }
    
    if (videoConnection != nil) {
        AVCaptureVideoOrientation avcaptureOrientation;
        
        if (_currentOrientation == UIInterfaceOrientationLandscapeRight) {
            avcaptureOrientation  = AVCaptureVideoOrientationLandscapeRight;
        } else if (_currentOrientation == UIInterfaceOrientationLandscapeLeft) {
            avcaptureOrientation  = AVCaptureVideoOrientationLandscapeLeft;
        } else {
            avcaptureOrientation = AVCaptureVideoOrientationPortrait;
        }
        
        [videoConnection setVideoOrientation:avcaptureOrientation];
        
        __weak __typeof__(self) weakSelf = self;
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
            __strong __typeof__(self) strongSelf = weakSelf;
            
            if (imageSampleBuffer != nil) {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
                } completionHandler:^(BOOL success, NSError * _Nullable error) {
                    
                }];
                
                self.instructionsLabel.hidden = YES;
                
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                image = [PTKGraphics fixImageOrientation:image];

                if (self.isCompact) {
                    CGSize size = image.size;
                    size.height = size.width / (self.view.width / self.view.height);
                    image = [PTKGraphics resampleImage:image size:size fill:YES];
                }

                strongSelf.imagePreviewLayer.hidden = FALSE;
                strongSelf.imagePreviewLayer.image = image;
                strongSelf.previewLayer.hidden = YES;
                
                strongSelf.flashButton.hidden = YES;
                strongSelf.flipCameraButton.hidden = YES;
                strongSelf.captureButton.hidden = YES;
                [strongSelf animateVideoSubmitButtonIntoView];
        
                [PTKEventTracker track:PTKEventTypeCameraCaptured withProperties:@{@"type":@"photo"}];
            }
        }];
    }
    
}

#pragma mark - multiple video composition

- (void)compileVideoAssetsAndPost {
    if (self.imagePreviewLayer.image != nil) {
        [self postMediaWithThumbnail:self.imagePreviewLayer.image withVideoURL:nil forType:PTKSelectedCameraPhoto];
    } else {
        
        if (self.videoAssets.count <= 0) {
            return;
        }
        
        [self showSpinner];
        
        CMTime currentCMTime = kCMTimeZero;
        AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
        AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compositionVideoTrack];
        float fps = 0;
        
        AVAssetTrack *firstVideoTrack = nil;
        BOOL firstVideoIsPortrait = NO;

        CGSize desiredSize;

        for (NSDictionary* assetDict in self.videoAssets) {
            AVAsset *asset = assetDict[@"asset"];
            AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
            AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
            CGSize temp = CGSizeApplyAffineTransform(videoTrack.naturalSize, videoTrack.preferredTransform);
            CGSize size = CGSizeMake(fabscg(temp.width), fabscg(temp.height));
            CGAffineTransform transform = videoTrack.preferredTransform;
            BOOL videoIsPortrait = size.height > size.width;
            
            [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:videoTrack atTime:currentCMTime error:nil];
            [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioTrack atTime:currentCMTime error:nil];
            
            if (!firstVideoTrack) {
                firstVideoTrack = videoTrack;
                firstVideoIsPortrait = videoIsPortrait;

                if (self.isCompact) {
                    desiredSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.height / (self.view.width / self.view.height));
                } else {
                    if (videoIsPortrait) {
                        desiredSize = CGSizeMake(videoTrack.naturalSize.height, videoTrack.naturalSize.width);
                    } else {
                        desiredSize = videoTrack.naturalSize;
                    }
                }
            }

            if (self.isCompact) {
                CGFloat x = ceilcg((size.height - desiredSize.height) / 2.0f);
                CGAffineTransform new = CGAffineTransformConcat(transform, CGAffineTransformMakeTranslation(0, -x));
                [layerInstruction setTransform:new atTime:currentCMTime];
            } else {
                if (firstVideoIsPortrait == videoIsPortrait) {
                    [layerInstruction setTransform:transform atTime:currentCMTime];
                } else if (firstVideoIsPortrait && !videoIsPortrait) {
                    CGFloat s = size.height / size.width;
                    CGAffineTransform new = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(s,s));
                    CGFloat y = (size.width - size.height * s) / 2.0f;
                    CGAffineTransform newer = CGAffineTransformConcat(new, CGAffineTransformMakeTranslation(0, y));
                    [layerInstruction setTransform:newer atTime:currentCMTime];
                } else if (!firstVideoIsPortrait && videoIsPortrait) {
                    CGFloat s = size.width / size.height;
                    CGAffineTransform new = CGAffineTransformConcat(transform, CGAffineTransformMakeScale(s,s));
                    CGFloat x = (size.height - size.width * s) / 2.0f;
                    CGAffineTransform newer = CGAffineTransformConcat(new, CGAffineTransformMakeTranslation(x, 0));
                    [layerInstruction setTransform:newer atTime:currentCMTime];
                }
            }
            
            
            currentCMTime = CMTimeAdd(currentCMTime, asset.duration);
            if (fps == 0) fps = videoTrack.nominalFrameRate;
        }
        
        AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        instruction.timeRange = CMTimeRangeMake(kCMTimeZero, currentCMTime);
        instruction.layerInstructions = @[layerInstruction];
        
        AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
        videoComposition.instructions = @[instruction];
        videoComposition.frameDuration = CMTimeMake(1, (int)fps);
        
        if (self.isCompact) {
            videoComposition.renderSize = CGSizeMake(compositionVideoTrack.naturalSize.height, compositionVideoTrack.naturalSize.height / (self.view.width / self.view.height));
        } else {
            if (firstVideoIsPortrait) {
                videoComposition.renderSize = CGSizeMake(compositionVideoTrack.naturalSize.height, compositionVideoTrack.naturalSize.width);
            } else {
                videoComposition.renderSize = compositionVideoTrack.naturalSize;
            }
        }
        
        NSURL *randomFinalVideoFileURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov", [[NSProcessInfo processInfo] globallyUniqueString]]]];
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset640x480];
        exportSession.outputFileType = AVFileTypeQuickTimeMovie;
        exportSession.outputURL = randomFinalVideoFileURL;
        exportSession.videoComposition = videoComposition;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    PTKLogError(@"Export failed: %@ %@", [[exportSession error] localizedDescription],[[exportSession error]debugDescription]);
                    break;
                }
                case AVAssetExportSessionStatusCancelled: {
                    PTKLogError(@"Export canceled");
                    break;
                }
                case AVAssetExportSessionStatusCompleted: {
                    PTKLog(@"Export complete!");
                    [self postCompletedVideoWithURL:randomFinalVideoFileURL];
                    break;
                }
                default: {
                    break;
                }
            }
            
            [self removeTemporaryVideos];
        }];
    }
    
}

- (void)removeTemporaryVideos {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSDictionary* video in self.videoAssets) {
            if (video[@"url"]) {
                NSError *error = nil;
                
                if (![[NSFileManager defaultManager] removeItemAtURL:video[@"url"] error:&error]) {
                    PTKLogError(@"Unable to delete temporary video file: %@", error);
                }
            }
        }
    });
}

@end
