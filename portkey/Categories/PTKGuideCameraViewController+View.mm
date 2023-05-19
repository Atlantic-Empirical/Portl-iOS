//
//  PTKGuideCameraViewController+View.m
//  portkey
//
//  Created by Robert Reeves on 5/1/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "PTKGuideCameraViewController+View.h"
#import "PTKGuideCameraViewController+Camera.h"
#import "PTKGuideCameraViewController+Actions.h"
#import "PTKCamera.h"

@interface PTKGuideCameraViewController () <UIGestureRecognizerDelegate>
@end


@implementation PTKGuideCameraViewController (View)


#pragma mark - view setup

- (void)loadUserControls {
    
    self.imagePreviewLayer = [[PTKImageView alloc] init];
    self.imagePreviewLayer.hidden = YES;
    self.imagePreviewLayer.backgroundColor = [UIColor blackColor];
    self.imagePreviewLayer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.imagePreviewLayer.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view insertSubview:self.imagePreviewLayer belowSubview:self.controlView];

    if ([PTKCamera sharedInstance].frozenImage) {
        self.frozenImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.frozenImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.frozenImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.frozenImageView.image = [PTKCamera sharedInstance].frozenImage;

        [self.view insertSubview:self.frozenImageView belowSubview:self.controlView];
    }
    
    self.captureButton = [[UIButton alloc] initWithFrame:CGRectMake((self.controlView.width/2)-33, (self.controlView.height/2)-13, 66, 66)];
    [self.captureButton addTarget:self action:@selector(touchDownCaptureButton) forControlEvents:UIControlEventTouchDown];
    [self.captureButton addTarget:self action:@selector(releaseCaptureButton) forControlEvents:UIControlEventTouchUpInside];
    [self.captureButton addTarget:self action:@selector(releaseCaptureButton) forControlEvents:UIControlEventTouchUpOutside];
    
    
    [self.captureButton setImage:[PTKGraphics circleImageWithColor:[[PTKColor almostWhiteColor] colorWithAlphaComponent:0.3f] andBackground:nil ofDiameter:55.0f] forState:UIControlStateNormal];
    self.captureButton.layer.borderColor = [PTKColor almostWhiteColor].CGColor;
    self.captureButton.layer.borderWidth = 6;
    self.captureButton.layer.cornerRadius = 32;
    
    [self.captureButton setImage:[PTKGraphics circleImageWithColor:[[PTKColor almostWhiteColor] colorWithAlphaComponent:0.5] andBackground:nil ofDiameter:55.0f] forState:UIControlStateHighlighted];
    [self.controlView addSubview:self.captureButton];
    self.dotWhite.center = self.captureButton.center;
    
    
    self.flipCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-64, (self.controlView.height/2)-7, 54.0f, 54.0f)];
    self.flipCameraButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.flipCameraButton setImage:[UIImage imageNamed:@"camera-flip"] forState:UIControlStateNormal];
    [self.flipCameraButton addTarget:self action:@selector(userDidTapFlipCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.flipCameraButton setTintColor:[PTKColor brandColor]];
    
    [self.view addSubview:self.flipCameraButton];
    
    self.labelTimer = [[UILabel alloc] initWithFrame:CGRectMake(20, (self.controlView.height/2)-7, 74.0f, 54.0f)];
    
    self.labelTimer.center = self.captureButton.center;
    
    self.labelTimer.textAlignment = NSTextAlignmentCenter;
    self.labelTimer.text = NSLocalizedString(@"0:00", nil);
    self.labelTimer.textColor = [PTKColor almostWhiteColor];
    self.labelTimer.font = [PTKFont mediumFontOfSize:14.0];
    self.labelTimer.alpha = 0;
    [self.controlView addSubview:self.labelTimer];
    
    
    self.flashButton = [[UIButton alloc] initWithFrame:CGRectMake(16, (self.controlView.height/2)-7, 54.0f, 54.0f)];
    self.flashButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.flashButton setImage:[[UIImage imageNamed:@"ic_flash_off_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self.flashButton setImage:[[UIImage imageNamed:@"ic_flash_on_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [self.flashButton addTarget:self action:@selector(flashButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.flashButton setTintColor:[PTKColor almostWhiteColor]];
    [self.view addSubview:self.flashButton];
    
    
    self.redoButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 25, 120, 44)];
    self.redoButton.center = CGPointMake(44, self.captureButton.center.y);
    [self.redoButton setTitle:localizedString(@"Retake") forState:UIControlStateNormal];
    [self.redoButton setTitleColor:[PTKColor almostWhiteColor] forState:UIControlStateNormal];
    self.redoButton.titleLabel.font =  [PTKFont mediumFontOfSize:14];
    self.redoButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    self.redoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.redoButton setTitleShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    self.redoButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.redoButton addTarget:self action:@selector(redo) forControlEvents:UIControlEventTouchUpInside];
    self.redoButton.hidden = YES;
    [self.controlView addSubview:self.redoButton];
}

- (void)setupView {
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
    self.view.clipsToBounds = YES;
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithImage:[PTKGraphics xImageWithColor:[PTKColor almostWhiteColor] backgroundColor:[UIColor clearColor] size:CGSizeMake(16.0, 16.0) lineWidth:2.0] style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
    [self.navigationItem setLeftBarButtonItem:cancel];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [PTKColor almostWhiteColor];
    
    self.controlView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-155, self.view.width, 155)];
    [self.view addSubview:self.controlView];
    
    self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activity.center = self.view.center;
    [self.activity startAnimating];
    [self.view addSubview:self.activity];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];

    _currentOrientation = UIInterfaceOrientationPortrait;
    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.accelerometerUpdateInterval = .2;
    _motionManager.gyroUpdateInterval = .2;

    __weak __typeof(self) weakSelf = self;
    [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
        __typeof(self) strongSelf = weakSelf;
        if (!strongSelf) return;

        if (error) {
            PTKLogError(@"CoreMotion Error: %@", error);
        } else if (!strongSelf.isCompact) {
            [strongSelf handleAccelerometerData:accelerometerData.acceleration];
        }
    }];
        
    UIImage *closeButtonImage = [UIImage imageNamed:@"button_close_down"];
    self.closeOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeOverlayButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [self.closeOverlayButton setImage:closeButtonImage forState:UIControlStateNormal];
    self.closeOverlayButton.imageView.transform = CGAffineTransformMakeRotation(((float)M_PI));
    [self.closeOverlayButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.closeOverlayButton.frame = CGRectMake(self.view.bounds.size.width - 45.0f, 20.0f, 40.0f, 40.0f);
    
    [self.view addSubview:self.closeOverlayButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];


    CGRect frame = [UIScreen mainScreen].bounds;
    frame.origin.x = ceilcg(self.view.width / 2.0f) - ceilcg(frame.size.width / 2.0f);
    frame.origin.y = ceilcg(MIN(self.view.height, frame.size.height) / 2.0f) - ceilcg(frame.size.height / 2.0f);
    
    self.previewLayer.frame = frame;
    self.imagePreviewLayer.frame = self.view.bounds;
    CGFloat offset = self.isPlayingMusic ? 195 : 155;

    if (self.isCompact) {
        self.controlView.frame = CGRectMake(0, self.view.height-offset, self.view.width, 155);
    } else {
        self.controlView.frame = CGRectMake(0, frame.size.height-offset, self.view.width, 155);
    }
    
    [self.flipCameraButton setOrigin:CGPointMake(14, 14)];
    [self.flashButton setOrigin:CGPointMake(self.flipCameraButton.maxX + 12, 14)];
}

- (void)setupGestures {
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
    [swipeGestureDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:swipeGestureDown];
    
    self.recordPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pannedDuringCapture:)];
    [self.captureButton addGestureRecognizer:self.recordPan];
    
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchToZoomRecognizer:)];
    [self.view addGestureRecognizer:twoFingerPinch];
}

- (void)handleAccelerometerData:(CMAcceleration)acceleration{
    UIInterfaceOrientation orientation = UIInterfaceOrientationPortrait;

    if (acceleration.x >= 0.75) {
        orientation = UIInterfaceOrientationLandscapeLeft;
    } else if (acceleration.x <= -0.75) {
        orientation = UIInterfaceOrientationLandscapeRight;
    } else if (acceleration.y <= -0.75) {
        orientation = UIInterfaceOrientationPortrait;
    } else if (acceleration.y >= 0.75) {
        orientation = UIInterfaceOrientationPortraitUpsideDown;
    }

    if (orientation != _currentOrientation) {
        _currentOrientation = orientation;
        [self updateInterfaceOrientation];
    }
}


#pragma mark - animations

- (void)animateCameraIntoView {
    // New footer cameraview shouldn't animate
    [self.view.layer insertSublayer:self.cameraFlipView.layer below:self.imagePreviewLayer.layer];
    [self.captureSession startRunning];
    [self.activity stopAnimating];
    self.activity.alpha = 0;
    self.cameraFlipView.alpha = 1;
    self.cameraFlipView.frame = CGRectMake(0, 0, self.view.width, self.view.height);

    if (self.frozenImageView) {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.frozenImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.frozenImageView removeFromSuperview];
            self.frozenImageView = nil;
        }];
    }
}

- (void)animateVideoSubmitButtonIntoView {
    self.redoButton.hidden = NO;
    self.redoButton.alpha = 0;
    
    CGFloat topOffset = 75.0f;
    CGFloat leftOffset = self.view.width-64.0f;
    
    self.submitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width, topOffset, 44.0f, 44.0f)];
    self.submitImageView.userInteractionEnabled = YES;
    [self.submitImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(compileVideoAssetsAndPost)]];
    UIImage* check = [UIImage imageNamed:@"text_checkmark"];
    
    PTKRoom *room = [[PTKWeakSharingManager roomsDataSource] objectWithId:self.roomId];
    UIColor *roomColor = room.roomColor;
    
    UIImage* circle = [PTKGraphics circleImageWithColor:roomColor andBackground:[UIColor clearColor] ofDiameter:44.0f];
    
    UIImage *newImage;
    
    CGRect rect = CGRectMake(0, 0, 44, 44);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [circle drawInRect:rect];
    [check drawInRect:CGRectMake(5, 5, 33, 33)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.submitImageView setImage:newImage];
    
    [self.controlView addSubview:self.submitImageView];
    
    CGFloat direction = -1.0f;
    self.submitImageView.transform = CGAffineTransformIdentity;
    
    [UIView animateKeyframesWithDuration:0.5 delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModePaced | UIViewAnimationOptionCurveEaseInOut
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.0 animations:^{
                                      self.submitImageView.transform = CGAffineTransformMakeRotation((CGFloat)M_PI * 2.0f / 3.0f * direction);
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.0 animations:^{
                                      self.submitImageView.transform = CGAffineTransformMakeRotation((CGFloat)M_PI * 4.0f / 3.0f * direction);
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.0 animations:^{
                                      self.submitImageView.transform = CGAffineTransformIdentity;
                                  }];
                                  self.redoButton.alpha = 1;
                              }
                              completion:^(BOOL finished) {}];
    [UIView animateWithDuration:1 animations:^{
        self.submitImageView.frame = CGRectMake(leftOffset, topOffset, 44, 44);
    } completion:^(BOOL finished) {
        [self updateInterfaceOrientation];
    }];
}

- (void)updateViewForVideo {
    [self configureVideoOrientation];
    self.currentSelection = PTKSelectedCameraVideo;
    self.isRecording = YES;
    [self startOrStopTorchForVideo];
    [self animateViewForVideo:YES];
    [self beginRecordingAnimation];
    self.captureButton.enabled = NO;
}

- (void)beginCircleRotationAnimation {
    if (!self.composingIndicator) {
        self.composingIndicator = [[UIView alloc] initWithFrame:CGRectMake(self.captureButton.frame.origin.x-3.5f, self.captureButton.frame.origin.y-3.5f, self.captureButton.width + 7.0f, self.captureButton.height + 7.0f)];
        self.composingIndicator.backgroundColor = [UIColor clearColor];
        self.composingIndicator.userInteractionEnabled = NO;
        
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = [PTKColor grayColor].CGColor;
        border.fillColor = nil;
        border.lineDashPattern = @[@4, @2];
        border.path = [UIBezierPath bezierPathWithRoundedRect:self.composingIndicator.bounds cornerRadius:(self.captureButton.width + 5.0f) / 2.0f].CGPath;
        border.frame = self.composingIndicator.bounds;
        [self.composingIndicator.layer addSublayer:border];
        
        UIImageView* composingOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
        composingOverlay.contentMode = UIViewContentModeCenter;
        composingOverlay.userInteractionEnabled = NO;
        
        [self.controlView addSubview:self.composingIndicator];
    } else {
        self.composingIndicator.hidden = NO;
    }
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithDouble: M_PI * 2.0];
    rotationAnimation.duration = 8.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [self.composingIndicator.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)animateViewForVideo:(BOOL)withTimer {
    [UIView transitionWithView:self.view duration:0.2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (withTimer) {
            self.labelTimer.alpha = 1;
        }
        
        self.flashButton.alpha = 0;
        self.instructionsLabel.alpha = 0;
    } completion:nil];
}

- (void)resetControls {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.currentSelection = PTKSelectedCameraPhoto;
        
        [self.navigationItem setRightBarButtonItem:nil];
        
        [self.videoAssets removeAllObjects];
        self.totalSeconds = 0;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.flipCameraButton.alpha = 1;
            
            if (!self.facingFront)
                self.flashButton.alpha = 1;
            
            self.labelTimer.text = NSLocalizedString(@"0:00", nil);
            self.labelTimer.alpha = 0;
            self.labelTimer.textColor = [PTKColor almostWhiteColor];
            self.spinnerView.hidden = YES;
        }];
    });
}



#pragma mark -

- (void)updateInterfaceOrientation {
    UIInterfaceOrientation orientation = _currentOrientation;
    if (self.currentSelection == PTKSelectedCameraBroadcast) orientation = UIInterfaceOrientationPortrait;

    [UIView transitionWithView:self.view duration:0.4 options:0 animations:^{
        
        switch (orientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.flipCameraButton.transform = CGAffineTransformMakeRotation((CGFloat)-M_PI_2);
                self.labelTimer.transform = CGAffineTransformMakeRotation((CGFloat)-M_PI_2);
                self.flashButton.transform = CGAffineTransformMakeRotation((CGFloat)-M_PI_2);
                self.imagePreviewLayer.transform = CGAffineTransformMakeRotation((CGFloat)-M_PI_2);
                self.redoButton.transform = CGAffineTransformMakeRotation((CGFloat)-M_PI_2);
                self.submitImageView.transform = CGAffineTransformMakeRotation((CGFloat)-M_PI_2);
                self.imagePreviewLayer.bounds = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
                break;
            case UIInterfaceOrientationLandscapeRight:
                self.flipCameraButton.transform = CGAffineTransformMakeRotation((CGFloat)M_PI_2);
                self.labelTimer.transform = CGAffineTransformMakeRotation((CGFloat)M_PI_2);
                self.flashButton.transform = CGAffineTransformMakeRotation((CGFloat)M_PI_2);
                self.imagePreviewLayer.transform = CGAffineTransformMakeRotation((CGFloat)M_PI_2);
                self.redoButton.transform = CGAffineTransformMakeRotation((CGFloat)M_PI_2);
                self.submitImageView.transform = CGAffineTransformMakeRotation((CGFloat)M_PI_2);
                self.imagePreviewLayer.bounds = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
                break;
            default:
                self.imagePreviewLayer.bounds = self.view.bounds;
                self.flipCameraButton.transform = CGAffineTransformMakeRotation(0);
                self.labelTimer.transform = CGAffineTransformMakeRotation(0);
                self.flashButton.transform = CGAffineTransformMakeRotation(0);
                self.imagePreviewLayer.transform = CGAffineTransformMakeRotation(0);
                self.redoButton.transform = CGAffineTransformMakeRotation(0);
                self.submitImageView.transform = CGAffineTransformMakeRotation(0);
                break;
        }
    } completion:nil];
}

// clears KEY-878
- (void)statusBarChanged:(NSNotification *)n {
    [self resetFrameFromStatusBarChange:self.view];
}

// clears KEY-878
- (void)resetFrameFromStatusBarChange:(UIView *)view {
    CGFloat statusBarHeight = STATUS_BAR_HEIGHT;
    
    if (statusBarHeight > 20.01) {
        return;
    }
    
    if ([view.superview isKindOfClass:[UIWindow class]]) {
        if (view.frame.origin.y >= 19.9f) {
            view.frame = (CGRect) {
                .origin.x = 0.0f,
                .origin.y = 0.0f,
                .size = view.superview.bounds.size
            };
        }
    }
    else {
        if (view.superview) {
            [self resetFrameFromStatusBarChange:view.superview];
        }
    }
}

- (void)showSpinner {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.spinnerView) {
            self.spinnerView = [[PTKLabeledSpinner alloc] initWithFrame:self.view.bounds];
            self.spinnerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [self.view addSubview:self.spinnerView];
            self.spinnerView.title = NSLocalizedString(@"Saving...", 0);
        }
        self.spinnerView.hidden = NO;
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
