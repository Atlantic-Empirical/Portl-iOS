//
//  PTKCameraZoomViewController.m
//  portkey
//
//  Created by Rodrigo Sieiro on 26/8/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKCameraZoomViewController.h"
#import "PTKStreamView.h"
#import "PTKCameraView.h"
#import "PTKCamera.h"

static const CGFloat kMessageAvatarSize = 50.0f;

@interface PTKCameraZoomViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
{
    UIControl *_backgroundView, *_cameraBackground, *_cameraOverlay;
    UIButton *_closeButton;
    UIView* _avatarContainerView, *_cameraOverlayContent;
    PTKImageView* _avatarImageView;
    UILabel* _nameLabel;
    
    UIButton *_flipCamera;
    UIButton *_muteVideo;
    UIButton *_muteAudio;
}

@property (nonatomic, weak) UIView *oldCameraSuperview;

@end

@implementation PTKCameraZoomViewController

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backgroundView = [[UIControl alloc] initWithFrame:self.view.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0;
    [_backgroundView addTarget:self action:@selector(backgroundTapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:_backgroundView atIndex:0];
    
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(self.view.width-50.0f, 20.0f, 44.0f, 44.0f);
    _closeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    _closeButton.alpha = 0;
    [_closeButton setTintColor:[PTKColor almostWhiteColor]];
    [_closeButton setImage:[UIImage imageNamed:@"ic_close-x-white-17x"] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(backgroundTapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    
    UISwipeGestureRecognizer* dismiss = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapAction:)];
    [dismiss setDirection:UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:dismiss];
    
    _cameraBackground = [[UIControl alloc] initWithFrame:self.view.bounds];
    _cameraBackground.backgroundColor = [UIColor blackColor];
    [_cameraBackground addTarget:self action:@selector(cameraBackgroundAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cameraBackground];
    
    _cameraOverlay = [[UIControl alloc] initWithFrame:self.view.bounds];
    _cameraOverlay.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
    _cameraOverlay.alpha = 0;
    _cameraOverlay.autoresizesSubviews = YES;
    [self.view addSubview:_cameraOverlay];
    _cameraOverlayContent = [[UIView alloc] initWithFrame:_cameraOverlay.bounds];
    _cameraOverlayContent.userInteractionEnabled = YES;
    [_cameraOverlayContent addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraOverlayAction:)]];
    _cameraOverlayContent.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_cameraOverlay addSubview:_cameraOverlayContent];
    
    _flipCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    _flipCamera.frame = CGRectMake(0, 0, 60.0f, 60.0f);
    _flipCamera.clipsToBounds = YES;
    _flipCamera.layer.cornerRadius = 30.0f;
    _flipCamera.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.6f];
    _flipCamera.tintColor = [UIColor blackColor];
    [_flipCamera setImage:[[UIImage imageNamed:@"camera_swap"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_flipCamera addTarget:self action:@selector(flipCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _muteVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    _muteVideo.frame = CGRectMake(0, 0, 60.0f, 60.0f);
    _muteVideo.clipsToBounds = YES;
    _muteVideo.layer.cornerRadius = 30.0f;
    _muteVideo.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.6f];
    _muteVideo.tintColor = [UIColor blackColor];
    [_muteVideo setImage:[UIImage imageNamed:@"video_off"] forState:UIControlStateNormal];
    [_muteVideo setImage:[[UIImage imageNamed:@"video_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [_muteVideo addTarget:self action:@selector(muteVideoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _muteAudio = [UIButton buttonWithType:UIButtonTypeCustom];
    _muteAudio.frame = CGRectMake(0, 0, 60.0f, 60.0f);
    _muteAudio.clipsToBounds = YES;
    _muteAudio.layer.cornerRadius = 30.0f;
    _muteAudio.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.6f];
    _muteAudio.tintColor = [UIColor blackColor];
    [_muteAudio setImage:[UIImage imageNamed:@"audio_off"] forState:UIControlStateNormal];
    [_muteAudio setImage:[[UIImage imageNamed:@"audio_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [_muteAudio addTarget:self action:@selector(muteAudioAction:) forControlEvents:UIControlEventTouchUpInside];
    [_cameraOverlayContent addSubview:_muteAudio];
    
    
    if ([_userId isEqualToString:SELF_ID()]) {
        
        [_cameraOverlayContent addSubview:_muteVideo];
        [_cameraOverlayContent addSubview:_flipCamera];
    }
    
    [self addAvatarView];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - Transition and Presentation

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* vc1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* con = [transitionContext containerView];
    UIView* v1 = vc1.view;
    UIView* v2 = vc2.view;
    
    BOOL isLandscape = (self.view.bounds.size.width > self.view.bounds.size.height);
    
    if (vc2 == self) { // Presenting
        [con addSubview:v2];
        v2.frame = v1.frame;
        
        _backgroundView.alpha = 0;
        
        CGRect frame = [self.delegate cameraZoom:self frameForUserId:self.userId];
        [self.view insertSubview:self.cameraView aboveSubview:_cameraBackground];
        
        self.cameraView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.cameraView.userInteractionEnabled = NO;
        self.cameraView.frame = frame;
        [self.cameraView setNeedsLayout];
        
        frame.size.width = MIN(self.view.width, self.view.height) - 40.0f;
        frame.size.height = frame.size.width;
        frame.origin.x = ceilcg(self.view.width / 2.0f) - ceilcg(frame.size.width / 2.0f);
        frame.origin.y = ceilcg(self.view.height / 2.0f) - ceilcg(frame.size.height / 2.0f);
        frame.origin.y = (isLandscape) ? 44.0 : ceilcg(self.view.height / 2.0f) - ceilcg(frame.size.height / 2.0f);
        
        _cameraBackground.frame = self.cameraView.frame;
        _cameraOverlay.frame = self.cameraView.frame;
        [self layoutOverlayButtons];
        
        [UIView animateWithDuration:0.25 animations:^{
            v1.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            _backgroundView.alpha = 0.8f;
            _closeButton.alpha = 1.0f;
            self.cameraView.frame = frame;
            _cameraBackground.frame = frame;
            _cameraOverlay.frame = frame;
            [self layoutOverlayButtons];
            
            [self.cameraView layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (!isLandscape) {
                _avatarContainerView.frame = CGRectMake(_cameraView.frame.origin.x - 4.0f, _cameraView.frame.origin.y - (kMessageAvatarSize * 0.7f), kMessageAvatarSize, kMessageAvatarSize);
                _nameLabel.frame = CGRectMake(_cameraView.frame.origin.x + _avatarContainerView.width + 10.0f, _cameraView.frame.origin.y - (kMessageAvatarSize * 0.8f), _nameLabel.width, _nameLabel.height);
                _nameLabel.textAlignment = NSTextAlignmentLeft;
                _nameLabel.backgroundColor = [UIColor clearColor];
            } else {
                _cameraView.frame = CGRectMake(_cameraView.frame.origin.x, 44, _cameraView.width, self.view.height-44);
                _avatarContainerView.frame = CGRectMake(_cameraView.frame.origin.x - 4.0f, _cameraView.frame.origin.y - (kMessageAvatarSize * 0.7f), kMessageAvatarSize, kMessageAvatarSize);
                _nameLabel.frame = CGRectMake(_cameraView.frame.origin.x + _avatarContainerView.width + 10.0f, _cameraView.frame.origin.y - (kMessageAvatarSize * 0.8f), _nameLabel.width, _nameLabel.height);
                _nameLabel.textAlignment = NSTextAlignmentLeft;
                _nameLabel.backgroundColor = [UIColor clearColor];
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                _avatarContainerView.alpha = 1;
                _nameLabel.alpha = 1;
            }];
            
            [transitionContext completeTransition:YES];
        }];
    } else { // Dismissing
        
        CGRect frame = [self.delegate cameraZoom:self frameForUserId:self.userId];
        if ([self.cameraView isKindOfClass:[PTKCameraView class]]) {
        }
        
        [self.cameraView setNeedsLayout];
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _nameLabel.alpha = 0;
            _avatarContainerView.alpha = 0;
            
            v2.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            _backgroundView.alpha = 0;
            _closeButton.alpha = 0;
            self.cameraView.frame = frame;
            _cameraBackground.frame = frame;
            _cameraOverlay.frame = frame;
            _cameraOverlay.alpha = 0;
            [self layoutOverlayButtons];
            [self.cameraView layoutIfNeeded];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

#pragma mark - Actions

- (void)cameraBackgroundAction:(id)sender {
    [self showOverlayWithAutoFade:NO];
}

- (void)cameraOverlayAction:(id)sender {
    [self hideOverlay];
}

- (void)backgroundTapAction:(id)sender {
    _nameLabel.alpha = 0;
    _avatarContainerView.alpha = 0;
    [self.delegate cameraZoomShouldDismiss:self];
}

- (void)flipCameraAction:(id)sender {
    
    if ([self.cameraView isKindOfClass:[PTKCameraView class]]) {
        PTKCameraView *cameraView = (PTKCameraView *)self.cameraView;
        [cameraView swapCameras];
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        
        _flipCamera.transform = CGAffineTransformScale(_flipCamera.transform, 0.8f, 0.8f);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:1.0f options:0 animations:^{
                    
                    _flipCamera.transform = CGAffineTransformIdentity;
                    
                } completion:^(BOOL finished) {
                    
                    [self layoutOverlayButtons];
                }];
            });
        }
    }];
}

- (void)muteVideoAction:(id)sender {
    [self showOverlayWithAutoFade:NO];
    
    if ([self.cameraView isKindOfClass:[PTKCameraView class]]) {
        PTKCameraView *cameraView = (PTKCameraView *)self.cameraView;
        [cameraView toggleVideoMute];
        [self layoutOverlayButtons];
    } else if ([self.cameraView isKindOfClass:[PTKStreamView class]]) {
        PTKStreamView *streamView = (PTKStreamView *)self.cameraView;
        [streamView toggleVideoMute];
        [self layoutOverlayButtons];
    }
}

- (void)muteAudioAction:(id)sender {
    [self showOverlayWithAutoFade:NO];
    
    if ([self.cameraView isKindOfClass:[PTKCameraView class]]) {
        PTKCameraView *cameraView = (PTKCameraView *)self.cameraView;
        [cameraView toggleAudioMute];
        [self layoutOverlayButtons];
    } else if ([self.cameraView isKindOfClass:[PTKStreamView class]]) {
        PTKStreamView *streamView = (PTKStreamView *)self.cameraView;
        [streamView toggleAudioMute];
        [self layoutOverlayButtons];
    }
}


#pragma mark - view setup

- (void)showOverlayWithAutoFade:(BOOL)autoFade {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideOverlay) object:nil];
    
    [self view];
    [self layoutOverlayButtons];
    
    if (_cameraOverlay.alpha != 0.7f) {
        
        _cameraOverlayContent.transform = CGAffineTransformScale(_cameraView.transform, 0.8f, 0.8f);
        
        [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.5f initialSpringVelocity:1.0f options:0 animations:^{
            _cameraOverlay.alpha = 0.7f;
            _cameraOverlayContent.transform = CGAffineTransformIdentity;
            
        } completion:nil];
    }
    
    if (autoFade)
        [self performSelector:@selector(hideOverlay) withObject:nil afterDelay:1.5f];
}

- (void)hideOverlay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideOverlay) object:nil];
    
    [UIView animateWithDuration:0.3f animations:^{
        _cameraOverlay.alpha = 0;
        _cameraOverlayContent.transform = CGAffineTransformScale(_cameraView.transform, 0.7f, 0.7f);
    } completion:^(BOOL finished) {
        _cameraOverlayContent.transform = CGAffineTransformIdentity;
    }];
}

- (BOOL)shouldAutorotate {
    BOOL isLandscape = (self.view.bounds.size.width > self.view.bounds.size.height);
    if (!isLandscape) {
        CGRect frame = [self.cameraView.superview convertRect:self.cameraView.frame toView:self.view];
        frame.size.width = MIN(self.view.width, self.view.height) - 40.0f;
        frame.size.height = frame.size.width;
        frame.origin.x = ceilcg(self.view.width / 2.0f) - ceilcg(frame.size.width / 2.0f);
        frame.origin.y = ceilcg(self.view.height / 2.0f) - ceilcg(frame.size.height / 2.0f);
        
        _cameraView.frame = frame;
        _cameraBackground.frame = frame;
        _cameraOverlay.frame = frame;
        
        _avatarContainerView.frame = CGRectMake(_cameraView.frame.origin.x - 4.0f, _cameraView.frame.origin.y - (kMessageAvatarSize * 0.7f), kMessageAvatarSize, kMessageAvatarSize);
        _nameLabel.frame = CGRectMake(_cameraView.frame.origin.x + _avatarContainerView.width + 10.0f, _cameraView.frame.origin.y - (kMessageAvatarSize * 0.8f), _nameLabel.width, _nameLabel.height);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.backgroundColor = [UIColor clearColor];
    } else {
        _cameraView.frame = CGRectMake(_cameraView.frame.origin.x, 44, _cameraView.width, self.view.height-44);
        _cameraBackground.frame = _cameraView.frame;
        _cameraOverlay.frame = _cameraView.frame;
        
        _avatarContainerView.frame = CGRectMake(_cameraView.frame.origin.x - 4.0f, _cameraView.frame.origin.y - (kMessageAvatarSize * 0.7f), kMessageAvatarSize, kMessageAvatarSize);
        _nameLabel.frame = CGRectMake(_cameraView.frame.origin.x + _avatarContainerView.width + 10.0f, _cameraView.frame.origin.y - (kMessageAvatarSize * 0.8f), _nameLabel.width, _nameLabel.height);
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.backgroundColor = [UIColor clearColor];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _avatarContainerView.alpha = 1;
        _nameLabel.alpha = 1;
    }];
    
    return YES;
}

- (void)addAvatarView {
    // Sender Avatar
    _avatarContainerView = [[UIView alloc] initWithFrame:CGRectMake(20, -kMessageAvatarSize, kMessageAvatarSize, kMessageAvatarSize)];
    _avatarContainerView.userInteractionEnabled = YES;
    _avatarContainerView.layer.borderColor = [UIColor blackColor].CGColor;
    _avatarContainerView.layer.borderWidth = 3.0;
    _avatarContainerView.layer.cornerRadius = _avatarContainerView.bounds.size.width / 2.0f;
    _avatarContainerView.clipsToBounds = YES;
    _avatarContainerView.alpha = 0;
    _avatarContainerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_avatarContainerView];
    
    _avatarImageView = [[PTKImageView alloc] initWithFrame:CGRectInset(_avatarContainerView.bounds, 2.0f, 2.0f)];
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.userInteractionEnabled = YES;
    [_avatarContainerView addSubview:_avatarImageView];
    
    CGSize optimizedAvatarSize = (CGSize) {
        .width = (kMessageAvatarSize - 4.0f),
        .height = (kMessageAvatarSize - 4.0f)
    };
    optimizedAvatarSize = [PTKGraphics ceiledSizeToPowerOfTwo:optimizedAvatarSize];
    
    NSString* avUrl = [[PTKData sharedInstance] avatarUrlForUserId:_userId];
    [_avatarImageView setImageWithUrl:avUrl];
    
    // User Name
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+10+kMessageAvatarSize, 66, self.view.width-kMessageAvatarSize+30, kMessageAvatarSize)];
    _nameLabel.font = [PTKFont regularFontOfSize:21.0f];
    _nameLabel.numberOfLines = 1;
    _nameLabel.userInteractionEnabled = YES;
    _nameLabel.alpha = 0;
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [PTKColor almostWhiteColor];
    [self.view addSubview:_nameLabel];
    
    if ([_userId isEqualToString:SELF_ID()]) {
        _nameLabel.text = localizedString(@"You");
    } else {
        _nameLabel.text = [[PTKData sharedInstance] cachedFirstNameForUserId:_userId];
    }
}

- (void)layoutOverlayButtons {
    CGPoint center = CGPointMake(ceilcg(_cameraOverlay.width / 2.0f), ceilcg(_cameraOverlay.height / 2.0f));
    
    if ([self.cameraView isKindOfClass:[PTKCameraView class]]) {
        PTKCameraView *cameraView = (PTKCameraView *)self.cameraView;
        
        _flipCamera.center = CGPointMake(center.x, center.y - 44.0f);
        _muteVideo.center = CGPointMake(center.x - 44.0f, center.y + 44.0f);
        _muteAudio.center = CGPointMake(center.x + 44.0f, center.y + 44.0f);
        
        _muteVideo.selected = !cameraView.videoMuted;
        _muteAudio.selected = !cameraView.audioMuted;
    } else {
        PTKStreamView *streamView = (PTKStreamView *)self.cameraView;
        
        _muteAudio.center = CGPointMake(center.x, center.y);
        
        _muteAudio.selected = !streamView.audioMuted;
    }
}

@end
