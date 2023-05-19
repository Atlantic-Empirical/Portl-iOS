//
//  PTKGuideCameraViewController.h
//  portkey
//
//  Created by Robert Reeves on 8/20/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//


typedef NS_ENUM(NSInteger, PTKSelectedCamera) {
    PTKSelectedCameraVideo,
    PTKSelectedCameraPhoto,
    PTKSelectedCameraBroadcast
};

#import <AVFoundation/AVFoundation.h>
#import <ImageIO/CGImageProperties.h>


#import "PTKLabeledSpinner.h"
#import "PTKBaseViewController.h"

@class PTKGuideCameraViewController, CMMotionManager;

@protocol PTKCameraViewControllerDelegate <NSObject>

@required

- (void)cameraViewControllerDidDismissCamera:(PTKGuideCameraViewController *)cameraViewController;

@optional

- (void)cameraViewControllerDidDisappear:(PTKGuideCameraViewController *)cameraViewController;
- (void)cameraViewControllerShouldExpand:(PTKGuideCameraViewController *)cameraViewController;
- (void)cameraViewControllerDidStartRecording:(PTKGuideCameraViewController *)cameraViewController;
- (void)cameraViewControllerDidEndRecording:(PTKGuideCameraViewController *)cameraViewController;
- (void)cameraViewControllerDidReset:(PTKGuideCameraViewController *)cameraViewController;

@end


@interface PTKGuideCameraViewController : PTKBaseViewController
{
    UIInterfaceOrientation _currentOrientation;
    CMMotionManager *_motionManager;
}


@property (nonatomic, weak) id<PTKCameraViewControllerDelegate> delegate;

- (instancetype)initWithRoomId:(NSString*)roomId;
- (void)tearDownCameraWithCompletion:(void(^)())completion;

/**
 track user finger engagement with capture button
 duration of finger touchDown decides between video or photo capture
 */
@property (assign) BOOL isFingerDown;


/**
 repeating timer that updates recording time status label
 */
@property (nonatomic) NSTimer* videoTimer;
@property (nonatomic) double totalSeconds;
@property (assign) BOOL isRecording;

/**
 preview layer for camera, takes up entire screen
 */
@property (nonatomic) AVCaptureVideoPreviewLayer* previewLayer;
@property (nonatomic) PTKImageView *imagePreviewLayer;
@property (nonatomic) UIImageView *frozenImageView;
/**
 AV session capture info - image, video & audio
 */
@property (nonatomic) AVCaptureSession* captureSession;
@property (nonatomic) AVCaptureStillImageOutput* stillImageOutput;
@property (nonatomic) AVCaptureMovieFileOutput* movieFileOutput;
@property (nonatomic) AVCaptureDeviceInput* videoInput;


/**
 AV session capture info - image, video & audio
 */
@property (nonatomic) UIButton* flipCameraButton;
@property (nonatomic) UIButton* flashButton;
@property (nonatomic) UIButton* redoButton;
@property (nonatomic) UIImageView* submitImageView;
@property (nonatomic) UIView* selectionLineView;
@property (nonatomic) UIButton* videoButton;
@property (nonatomic) UILabel* labelTimer;
@property (nonatomic) UIButton* photoButton;
@property (nonatomic) UIButton* captureButton;
@property (nonatomic) UIPanGestureRecognizer* recordPan;
@property (nonatomic) UIButton* broadcastButton;
@property (nonatomic) UILabel* instructionsLabel;
@property (assign) BOOL facingFront;
@property (nonatomic, assign) PTKSelectedCamera currentSelection;
@property (assign) CGRect defaultCameraRect;
@property (nonatomic) AVCaptureDevice* videoDevice;
@property (nonatomic) PTKLabeledSpinner* spinnerView;
@property (nonatomic) UIView* cameraFlipView;
@property (nonatomic) UIActivityIndicatorView* activity;
@property (nonatomic) UIView* composingIndicator;
@property (nonatomic) BOOL capturingVideo;
@property (nonatomic) NSMutableArray* videoAssets;
@property (nonatomic) NSString* roomId;
@property (nonatomic) UIImageView* dotWhite;
@property (nonatomic) UIView* controlView;
@property (nonatomic) UIButton* closeOverlayButton;
@property (nonatomic) BOOL isCompact;
@property (nonatomic) BOOL isPlayingMusic;

- (void)postCompletedVideoWithURL:(NSURL *)fileURL;
- (void)postMediaWithThumbnail:(UIImage *)image withVideoURL:(NSString *)videoURL forType:(PTKSelectedCamera)type;
- (void)closeButtonAction:(id)sender;


@end
