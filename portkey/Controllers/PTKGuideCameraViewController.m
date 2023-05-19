
//
//  PTKGuideCameraViewController.m
//  portkey
//
//  Created by Robert Reeves on 8/20/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "PTKGuideCameraViewController.h"
#import "PTKGuideCameraViewController+View.h"
#import "PTKGuideCameraViewController+Actions.h"
#import "PTKGuideCameraViewController+Camera.h"
#import "PTKMessagePreviewViewController.h"
#import "PTKMessagePreviewTransitionDelegate.h"
#import "PTKPhotosMessage.h"
#import "PTKVideoMessage.h"
#import "PTKMessageSender.h"
#import <Photos/Photos.h>


#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@interface PTKGuideCameraViewController () <PTKMessagePreviewViewControllerDelegate, UIGestureRecognizerDelegate>
@end


@implementation PTKGuideCameraViewController

#pragma mark - configuration

- (instancetype)initWithRoomId:(NSString*)roomId {
    self = [super init];
    
    _roomId = roomId;
    
    self.currentSelection = PTKSelectedCameraPhoto;
    self.capturingVideo = NO;
    self.totalSeconds = 1;
    self.facingFront = NO;
    
    self.isFingerDown = NO;
    
    return self;
}

- (void)dealloc {
    [_motionManager stopAccelerometerUpdates];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isCompact = YES;
    
    [self setupView];
    [self loadUserControls];
    [self setupGestures];

    _videoAssets = [NSMutableArray arrayWithCapacity:0];

    [[PTKAudio sharedInstance] requestRecordWithCompletion:^(BOOL changed) {
        [self setupCamera];
    }];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.presentedViewController && ![self.presentedViewController isKindOfClass:[UIActivityViewController class]] && ![self.presentedViewController isKindOfClass:[UIAlertController class]]) {
        return [self.presentedViewController supportedInterfaceOrientations];
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

#pragma mark -

- (void)postCompletedVideoWithURL:(NSURL *)fileURL {
    // save to photo album
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCreationRequest creationRequestForAssetFromVideoAtFileURL:fileURL];
    } completionHandler:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.spinnerView.hidden = YES;
        [self postMediaWithThumbnail:self.videoAssets.firstObject[@"thumb"] withVideoURL:fileURL.path forType:PTKSelectedCameraVideo];
    });
}


#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopTorch];
        [self.videoTimer invalidate];
        
        self.totalSeconds += CMTimeGetSeconds(self.movieFileOutput.recordedDuration);
        self.labelTimer.text = [self formattedTime:self.totalSeconds];
        self.captureButton.enabled = YES;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.flipCameraButton.alpha = 1;
        }];
    });
    
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong __typeof__(self) strongSelf = weakSelf;
        
        AVURLAsset* asset = [AVURLAsset assetWithURL:outputFileURL];
        
        AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        imageGenerator.maximumSize = CGSizeMake(640.0f, 640.0f);
        imageGenerator.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
        
        if (!error && image != nil) {
            [PTKEventTracker track:PTKEventTypeCameraCaptured withProperties:@{@"type": @"video"}];
            
            UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
            CGImageRelease(image);

            if (self.isCompact) {
                thumb = [PTKGraphics resampleImage:thumb size:self.view.bounds.size fill:YES];
            }
            
            [self.videoAssets addObject:@{@"asset":asset, @"thumb":thumb, @"url":outputFileURL}];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self animateVideoSubmitButtonIntoView];
            });
        } else if (error.code == -1100) {
            // If you repeatedly tap on the capture button, sometimes it will generate empty videos
            // Couldn't figure out why yet, so for now just skip
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                PTKLogError(@"Failed to get video thumbnail: %@", error);
                [strongSelf showAlertWithTitle:NSLocalizedString(@"Error",0) andMessage:NSLocalizedString(@"Something went wrong. Try again.",0)];
            });
        }
    });
}



#pragma mark - PTKMessagePreviewViewController & Delegate

- (void)postMediaWithThumbnail:(UIImage *)image withVideoURL:(NSString *)videoURL forType:(PTKSelectedCamera)type {
    switch (type) {
        case PTKSelectedCameraPhoto: {
            PTKPhotosMessage *message = [PTKPhotosMessage messageWithRoomId:_roomId body:nil images:@[image] assets:nil];
            message.fromCamera = YES;
            
            [[PTKMessageSender sharedInstance] enqueueMessage:message andSend:YES];
            [_delegate cameraViewControllerDidDismissCamera:self];

            break;
        }
        case PTKSelectedCameraVideo: {
            [_submitImageView removeFromSuperview];
            _submitImageView = nil;
            
            
            // Stick in a fake message while we wait for the transcode to complete
            NSURL *finalVideoURL = [NSURL fileURLWithPath:videoURL];
            AVAsset *asset = [AVAsset assetWithURL:finalVideoURL];

            PTKVideoMessage *message = [PTKVideoMessage messageWithRoomId:self.roomId body:nil image:image originalPath:videoURL duration:self.totalSeconds];
            message.fromCamera = true;
            message.assets = @[asset];
            message.shouldDeleteOriginals = YES;

            PTKMessagePreviewViewController *viewController = [[PTKMessagePreviewViewController alloc] initWithMessage:message];
            viewController.delegate = self;
            [self presentViewController:viewController animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

- (void)messagePreview:(PTKMessagePreviewViewController *)messagePreview dismissWithSuccess:(BOOL)success {
    if (success) {
        PTKMessagePreviewTransitionDelegate *messageTransitionDelegate;
        
        if ([self.navigationController.transitioningDelegate isKindOfClass:[PTKMessagePreviewTransitionDelegate class]]) {
            messageTransitionDelegate = (PTKMessagePreviewTransitionDelegate *)self.navigationController.transitioningDelegate;
        } else if ([self.transitioningDelegate isKindOfClass:[PTKMessagePreviewTransitionDelegate class]]) {
            messageTransitionDelegate = (PTKMessagePreviewTransitionDelegate *)self.transitioningDelegate;
        }
        
        [messageTransitionDelegate setFromFrame:[messagePreview messageViewFromFrame]];
        [messageTransitionDelegate setMessageView:messagePreview.messageView];
        [self.delegate cameraViewControllerDidDismissCamera:self];
    } else {
        [self redo];
        [self resetControls];
        [messagePreview dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - closeButton stuff
- (void)closeButtonAction:(id)sender {
    
    UIButton *closeButton = (UIButton *)sender;
    if (closeButton.tag == 1) {
        [self.delegate cameraViewControllerDidDismissCamera:self];
    } else {
        [_delegate cameraViewControllerShouldExpand:self];
    }
}

#pragma mark - 

- (void)tearDownCameraWithCompletion:(void (^)())completion {
    [self tearDownCameraInternalWithCompletion:completion];
}

@end
