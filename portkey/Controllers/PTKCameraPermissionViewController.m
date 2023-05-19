//
//  PTKCameraPermissionViewController.m
//  portkey
//
//  Created by Rodrigo Sieiro on 24/7/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKCameraPermissionViewController.h"

@interface PTKCameraPermissionViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
{
    UIView *_contentView;
    UILabel *_titleLabel;
    UIImageView *_cameraImage;
    UILabel *_contentLabel;
    UIButton *_settingsButton;
    UIButton *_audioOnlyButton;
}

@end

@implementation PTKCameraPermissionViewController

- (instancetype)init {
    if (!(self = [super init])) return nil;

    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self listenFor:UIApplicationDidBecomeActiveNotification selector:@selector(checkForCameraPermission)];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];

    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 240.0f)];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _contentView.backgroundColor = [PTKColor almostWhiteColor];
    _contentView.clipsToBounds = YES;
    _contentView.layer.cornerRadius = 4.0f;
    _contentView.center = self.view.center;
    [self.view addSubview:_contentView];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 26.0f, _contentView.width, 20.0f)];
    _titleLabel.font = [PTKFont boldFontOfSize:15.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = NSLocalizedString(@"Camera Permission Required",0);
    [_contentView addSubview:_titleLabel];

    _cameraImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 68.0f, _contentView.width, 32.0f)];
    _cameraImage.contentMode = UIViewContentModeCenter;
    _cameraImage.image = [UIImage imageNamed:@"camera_settings"];
    [_contentView addSubview:_cameraImage];

    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 115.0f, _contentView.width, 35.0f)];
    _contentLabel.font = [PTKFont regularFontOfSize:14.0f];
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.numberOfLines = 2;
    _contentLabel.text = [NSString stringWithFormat:NSLocalizedString(@"You must grant Airtime permission to\nyour camera if you want to %@!",0), self.action];
    [_contentView addSubview:_contentLabel];

    _settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingsButton.frame = CGRectMake(0, 0, 120.0f, 30.0f);
    _settingsButton.center = CGPointMake(ceilcg(_contentView.width / 2.0f), 184.0f);
    _settingsButton.backgroundColor = [PTKColor brandColor];
    _settingsButton.titleLabel.font = [PTKFont regularFontOfSize:14.0f];
    _settingsButton.clipsToBounds = YES;
    _settingsButton.layer.cornerRadius = 3.0f;
    [_settingsButton setTitleColor:[PTKColor almostWhiteColor] forState:UIControlStateNormal];
    [_settingsButton setTitle:NSLocalizedString(@"Go to Settings",0) forState:UIControlStateNormal];
    [_settingsButton addTarget:self action:@selector(settingsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_settingsButton];

    _audioOnlyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _audioOnlyButton.frame = CGRectMake(0, 212.0f, _contentView.width, 15.0f);
    _audioOnlyButton.titleLabel.font = [PTKFont regularFontOfSize:12.0f];
    [_audioOnlyButton setTitleColor:[PTKColor grayColor] forState:UIControlStateNormal];
    [_audioOnlyButton setTitle:NSLocalizedString(@"or continue with audio only",0) forState:UIControlStateNormal];
    [_audioOnlyButton addTarget:self action:@selector(audioOnlyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_audioOnlyButton];
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

    if (vc2 == self) { // Presenting
        [con addSubview:v2];
        v2.frame = v1.frame;
        v2.alpha = 0.0f;

        [UIView animateWithDuration:0.25 animations:^{
            v1.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            v2.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else { // Dismissing
        [UIView animateWithDuration:0.25 animations:^{
            v2.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            v1.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

#pragma mark - Custom Actions

- (void)setAction:(NSString *)action {
    _action = [action copy];
    _contentLabel.text = [NSString stringWithFormat:NSLocalizedString(@"You must grant Airtime permission to\nyour camera if you want to %@!",0), _action];
}

- (void)checkForCameraPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (status == AVAuthorizationStatusAuthorized) {
        void (^block)(BOOL hasPermissionNow) = self.completionBlock;
        [self dismissViewControllerAnimated:YES completion:^{
            if (block) block(YES);
        }];
    }
}

- (void)settingsButtonAction {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (void)audioOnlyButtonAction {
    void (^block)(BOOL hasPermissionNow) = self.completionBlock;
    [self dismissViewControllerAnimated:YES completion:^{
        if (block) block(NO);
    }];
}

@end
