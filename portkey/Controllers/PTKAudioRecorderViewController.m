//
//  PTKAudioRecorderViewController.m
//  portkey
//
//  Created by Rodrigo Sieiro on 11/8/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKAudioRecorderViewController.h"
#import "PTKPermissionManager.h"
#import "PTKMCHammerView.h"
#import "PTKVUMeterView.h"
#import "PTKWaveformView.h"
#import "PTKAudioPlayer.h"
#import "PTKAudioPlayerTrack.h"
#import "PTKMessageSender.h"
#import "PTKAudioMessage.h"
#import "PTKPassiveGestureRecognizer.h"

typedef NS_ENUM(NSInteger, PTKAudioRecorderViewState) {
    PTKAudioRecorderViewStateDefault,
    PTKAudioRecorderViewStateRecording,
    PTKAudioRecorderViewStatePreparingToSend,
    PTKAudioRecorderViewStateReadyToSend
};


@interface PTKAudioRecorderViewController () <AVAudioRecorderDelegate, PTKWaveformViewDelegate, PTKAudioPlayerDelegate>
{
    UIButton *_cancelButton, *_playButton;
    UILabel *_warningLabel, *_timeLabel;
    UIView *_backgroundView, *_recordButtonArea;
    UIImageView *_recordButton;
    UIActivityIndicatorView *_aiLoading;
    PTKVUMeterView *_vuMeter;
    PTKWaveformView *_waveform;
    CADisplayLink *_displayLink;
    UIColor *_backgroundColor, *_foregroundColor;
    
    PTKAudioPlayer *_audioPlayer;
    PTKAudioRecorderViewState _viewState;
    AVAudioRecorder *_audioRecorder;
    BOOL _didCancelRecording;
    NSString *_roomId;
    NSURL *_fileURL;
    NSTimeInterval _duration;
    CGFloat _backgroundPosition;
    
    PTKPassiveGestureRecognizer *_windowTouch;
    UITapGestureRecognizer *_tap;
    UILongPressGestureRecognizer *_longPress;
    BOOL _longPressActive;
}

@end

@implementation PTKAudioRecorderViewController

- (instancetype)initWithRoomId:(NSString *)roomId {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) return nil;
    
    _roomId = roomId;
    
    return self;
}

- (void)loadView {
    self.view = [[PTKMCHammerView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.clipsToBounds = YES;
    _backgroundView.layer.cornerRadius = _recordButton.width / 2.0f;
    _backgroundView.layer.shouldRasterize = YES;
    _backgroundView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _backgroundView.layer.borderColor = [PTKColor almostWhiteColor].CGColor;
    _backgroundView.layer.borderWidth = 1.0f;
    _backgroundView.alpha = 0;
    [self.view addSubview:_backgroundView];
    
    CGFloat xSize = 15.0f;
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_cancelButton setImage:[PTKGraphics xImageWithColor:[UIColor blackColor] backgroundColor:[UIColor clearColor] size:CGSizeMake(xSize, xSize) lineWidth:3.0f roundedCorners:YES] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"pause_button"] forState:UIControlStateSelected];
    [_playButton addTarget:self action:@selector(playPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:_playButton];
    
    _recordButtonArea = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44.0f, 44.0f)];
    _recordButtonArea.userInteractionEnabled = YES;
    [self.view addSubview:_recordButtonArea];
    
    _recordButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10.0f, 10.0f)];
    _recordButton.clipsToBounds = YES;
    _recordButton.layer.cornerRadius = _recordButton.width / 2.0f;
    _recordButton.layer.shouldRasterize = YES;
    _recordButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _recordButton.contentMode = UIViewContentModeCenter;
    _recordButton.tintColor = [PTKColor almostWhiteColor];
    [self.view addSubview:_recordButton];
    
    _aiLoading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _aiLoading.hidesWhenStopped = YES;
    [self.view addSubview:_aiLoading];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [PTKFont regularFontOfSize:14.0f];
    _timeLabel.text = NSLocalizedString(@"0:00", nil);
    _timeLabel.alpha = 0;
    [self.view addSubview:_timeLabel];
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_recordButtonArea addGestureRecognizer:_tap];
    
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    _longPress.minimumPressDuration = 0.2f;
    [_recordButtonArea addGestureRecognizer:_longPress];
    
    [self setViewState:PTKAudioRecorderViewStateDefault];
}

- (void)viewDidLayoutSubviews {
    CGRect textFrame = [self.delegate frameForAudioRecorderBorder:self];
    CGFloat rightEdge = IS_IPHONE5_OR_OLDER ? 10.0f : 18.0f;
    CGFloat buttonSize = 30.0f;
    
    if (CGRectIsEmpty(textFrame)) {
        textFrame = CGRectMake(_backgroundPosition, 7.0f, self.view.width - _backgroundPosition - rightEdge, self.view.height - 14.0f);
    } else {
        rightEdge = self.view.width - CGRectGetMaxX(textFrame);
        buttonSize = textFrame.size.height - 6.0f;
        
        textFrame.origin.x = MIN(_backgroundPosition, textFrame.origin.x);
        textFrame.size.width = self.view.width - textFrame.origin.x - rightEdge;
    }
    
    _backgroundView.frame = textFrame;
    _backgroundView.layer.cornerRadius = _backgroundView.height / 2.0f;
    
    _recordButton.frame = CGRectMake(self.view.width - buttonSize - rightEdge - 3.0f, ceilcg(self.view.height / 2.0f) - ceilcg(buttonSize / 2.0f), buttonSize, buttonSize);
    _recordButton.layer.cornerRadius = buttonSize / 2.0f;
    _recordButtonArea.center = _recordButton.center;
    _aiLoading.center = _recordButton.center;
    
    _cancelButton.frame = CGRectMake(0, 0, 50.0f, self.view.height);
    _playButton.frame = CGRectMake(0, 0, 40.0f, _backgroundView.height);
    _timeLabel.frame = CGRectMake(_recordButton.x - 45.0f, 0, 45.0f, self.view.height);
    _vuMeter.frame = CGRectMake(10.0f, 0, _backgroundView.width - _recordButton.width - 60.0f, _backgroundView.height);
    _waveform.frame = CGRectMake(40.0f, 4.0f, _backgroundView.width - _recordButton.width - 90.0f, _backgroundView.height - 8.0f);
}

- (void)setViewState:(PTKAudioRecorderViewState)state {
    _viewState = state;
    
    if ([self hideWarning]) return;
    [self.view setNeedsLayout];
    
    switch (state) {
        case PTKAudioRecorderViewStateDefault: {
            _recordButton.backgroundColor = _roomColor;
            _recordButton.image = [[UIImage imageNamed:@"mic-small"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            _recordButton.backgroundColor = [PTKColor tintColorWithRoomColor:_roomColor];

            _backgroundPosition = IS_IPHONE5_OR_OLDER ? 157.0f : 197.0f;
            _longPress.enabled = YES;
            
            PTKWaveformView *waveform = _waveform;
            _waveform = nil;
            
            [_aiLoading stopAnimating];
            [self stopMeters];
            
            [UIView animateWithDuration:0.2f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                [self.view layoutIfNeeded];
                self.view.backgroundColor = [UIColor clearColor];
                _backgroundView.backgroundColor = [UIColor clearColor];
                _timeLabel.alpha = 0;
                _cancelButton.alpha = 0;
                _playButton.alpha = 0;
                waveform.alpha = 0;
            } completion:^(BOOL finished) {
                [waveform removeFromSuperview];
                _backgroundView.alpha = 0;
            }];
            
            break;
        }
        case PTKAudioRecorderViewStateRecording: {
            _recordButton.backgroundColor = [UIColor redColor];
            _recordButton.image = nil;
            _timeLabel.textColor = [UIColor redColor];
            _backgroundView.alpha = 1.0f;
            _backgroundPosition = 50.0f;
            _longPress.enabled = YES;
            
            [_aiLoading stopAnimating];
            [self startMeters];
            
            [UIView animateWithDuration:0.2f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                [self.view layoutIfNeeded];
                self.view.backgroundColor = _backgroundColor;
                _backgroundView.backgroundColor = _backgroundColor;
                _timeLabel.alpha = 1.0f;
                _cancelButton.alpha = 0;
                _playButton.alpha = 0;
            } completion:nil];
            
            break;
        }
        case PTKAudioRecorderViewStatePreparingToSend: {
            _recordButton.backgroundColor = [PTKColor brandColor];
            _recordButton.image = nil;
            _timeLabel.textColor = [PTKColor brandColor];
            _backgroundView.alpha = 1.0f;
            _backgroundPosition = 50.0f;
            _longPress.enabled = NO;
            
            [_aiLoading startAnimating];
            [self stopMeters];
            
            [UIView animateWithDuration:0.2f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                [self.view layoutIfNeeded];
                self.view.backgroundColor = _backgroundColor;
                _backgroundView.backgroundColor = _backgroundColor;
                _timeLabel.alpha = 1.0f;
                _cancelButton.alpha = 0;
                _playButton.alpha = 0;
            } completion:nil];
            
            break;
        }
        case PTKAudioRecorderViewStateReadyToSend: {
            _recordButton.backgroundColor = [PTKColor brandColor];
            _recordButton.image = [[UIImage imageNamed:@"send-small"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            _timeLabel.textColor = [PTKColor brandColor];
            _backgroundView.alpha = 1.0f;
            _backgroundPosition = 50.0f;
            _longPress.enabled = NO;
            
            [_aiLoading stopAnimating];
            [self stopMeters];
            
            [UIView animateWithDuration:0.2f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                [self.view layoutIfNeeded];
                self.view.backgroundColor = _backgroundColor;
                _backgroundView.backgroundColor = _backgroundColor;
                _timeLabel.alpha = 1.0f;
                _cancelButton.alpha = 1.0f;
                _playButton.alpha = 1.0f;
            } completion:nil];
            
            break;
        }
    }
}

- (void)showWarning:(NSString *)warning {
    _recordButton.transform = CGAffineTransformMakeTranslation(10.0f, 0);
    [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.2f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        _recordButton.transform = CGAffineTransformIdentity;
    } completion:nil];
    
    if (warning) {
        if (!_warningLabel) {
            _warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _backgroundView.width - _recordButton.width, _backgroundView.height)];
            _warningLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            _warningLabel.font = [PTKFont regularFontOfSize:IS_IPHONE5_OR_OLDER ? 14.0f : 16.0];

            if (_roomColor.isBright) {
                _warningLabel.textColor = [UIColor blackColor];
            } else {
                _warningLabel.textColor = [UIColor lightGrayColor];
            }

            _warningLabel.textAlignment = NSTextAlignmentCenter;
            _warningLabel.alpha = 0;
        }
        
        _warningLabel.text = warning;
        [_backgroundView addSubview:_warningLabel];
        
        [self viewDidLayoutSubviews];
        
        _backgroundView.alpha = 1.0f;
        _backgroundPosition = IS_IPHONE5_OR_OLDER ? 44.0f : 50.0f;
        [self.view setNeedsLayout];
        
        [UIView animateWithDuration:0.2f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
            _backgroundView.backgroundColor = _backgroundColor;
            _warningLabel.alpha = 1.0f;
        } completion:nil];
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideWarning) object:nil];
        [self performSelector:@selector(hideWarning) withObject:nil afterDelay:1.5f];
    }
}

- (BOOL)hideWarning {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideWarning) object:nil];
    
    if (_warningLabel) {
        UILabel *warningLabel = _warningLabel;
        _warningLabel = nil;
        
        [UIView animateWithDuration:0.2f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            warningLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [warningLabel removeFromSuperview];
        }];
        
        [self setViewState:_viewState];
        return YES;
    }
    
    return NO;
}

- (void)setRoomColor:(UIColor *)roomColor {
    if (![roomColor isEqual:_roomColor]) {
        _backgroundColor = roomColor;
        _roomColor = roomColor;

        if (roomColor.isBright) {
            _foregroundColor = [UIColor blackColor];
            _cancelButton.tintColor = [UIColor blackColor];
        } else {
            _foregroundColor = [PTKColor almostWhiteColor];
            _cancelButton.tintColor = [UIColor lightGrayColor];
        }

        _backgroundView.layer.borderColor = _foregroundColor.CGColor;
        [self setViewState:_viewState];
        
    }
}

- (void)sendMessage {
    PTKAudioMessage *message = [PTKAudioMessage messageWithRoomId:_roomId body:nil originalPath:_fileURL.path duration:_duration];
    message.shouldDeleteOriginals = YES;
    
    [[PTKMessageSender sharedInstance] enqueueMessage:message andSend:YES];
    
    [self setViewState:PTKAudioRecorderViewStateDefault];
}

#pragma mark - Actions

- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (_viewState == PTKAudioRecorderViewStateDefault) {
        [self showWarning:NSLocalizedString(@"Tap and hold to record audio", 0)];
    } else if (_viewState == PTKAudioRecorderViewStateReadyToSend) {
        [self sendMessage];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        _longPressActive = YES;
        [self requestMicPermissionAndContinue];
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        _longPressActive = NO;
        [self stopRecording];
    } else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateFailed) {
        _longPressActive = NO;
        [self cancelRecording];
    }
}

- (void)cancelAction:(id)sender {
    if (_fileURL) {
        NSError *error = nil;
        if (![[NSFileManager defaultManager] removeItemAtURL:_fileURL error:&error]) {
            PTKLogError(@"Error removing temp file: %@", error);
        }
    }
    
    [self setViewState:PTKAudioRecorderViewStateDefault];
}

- (void)playPauseAction:(id)sender {
    if (!_playButton.selected) {
        if (!_audioPlayer) {
            PTKAudioPlayerTrack *track = [[PTKAudioPlayerTrack alloc] initWithURL:_fileURL name:nil artist:nil];
            _audioPlayer = [[PTKAudioPlayer alloc] initWithAudioTap:NO];
            _audioPlayer.shouldPauseWhenOthersPlay = YES;
            _audioPlayer.delegate = self;
            [_audioPlayer loadTracks:@[track]];
        }
        
        [_audioPlayer play];
    } else {
        [_audioPlayer pause];
    }
}

- (void) gestureWhileRecording:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self cancelRecording];
    }
}

#pragma mark - Audio Recording

- (void)requestMicPermissionAndContinue {
    if ([PTKPermissionManager currentMicrophonePermissionState] != PTKPermissionStateAuthorized) {
        __weak typeof(self) weakSelf = self;
        
        [PTKPermissionManager requestMicAccessAtLocation:NSStringFromClass([self class]) withCompletion:^(BOOL granted) {
            typeof(self) strongSelf = weakSelf;
            if (!strongSelf) return;
            
            if (granted) {
                [strongSelf startAudioSessionAndContinue];
            } else {
                strongSelf->_longPressActive = NO;
                [strongSelf showWarning:NSLocalizedString(@"Microphone permission denied", 0)];
            }
        }];
    } else {
        [self startAudioSessionAndContinue];
    }
}

- (void)startAudioSessionAndContinue {
    __weak typeof(self) weakSelf = self;
    
    [[PTKAudio sharedInstance] requestRecordWithCompletion:^(BOOL changed) {
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        [strongSelf startRecording];
    }];
}

- (void)startRecording {
    // Exit if already recording
    if (_audioRecorder) return;
    
    // Exit if gesture was canceled
    if (!_longPressActive) {
        [self cancelRecording];
        return;
    }
    
    PTKLogDebug(@"Recording Started");
    _didCancelRecording = NO;
    
    NSDictionary *settings = @{AVFormatIDKey: @(kAudioFormatMPEG4AAC),
                               AVSampleRateKey: @(22050.0f),
                               AVNumberOfChannelsKey: @(1),
                               AVEncoderAudioQualityKey: @(AVAudioQualityMedium),
                               AVSampleRateConverterAudioQualityKey: @(AVAudioQualityMedium)};
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", [[NSProcessInfo processInfo] globallyUniqueString]]];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    _audioRecorder.delegate = self;
    
    if (!_audioRecorder && error) {
        PTKLogError(@"%@", error);
        [self cancelRecording];
    }
    
    if (![_audioRecorder prepareToRecord]) {
        [self cancelRecording];
        return;
    }

    // Register tap handler to cancel on any window interaction
    _windowTouch = [[PTKPassiveGestureRecognizer alloc] initWithTarget:self action:@selector(gestureWhileRecording:)];
    [[[[UIApplication sharedApplication] delegate] window] addGestureRecognizer:_windowTouch];
    

    [self setViewState:PTKAudioRecorderViewStateRecording];
    [_audioRecorder setMeteringEnabled:YES];
    [_audioRecorder record];
}

- (void)stopRecording {
    if (_viewState != PTKAudioRecorderViewStateRecording) {
        return;
    }
    PTKLogDebug(@"Recording Stopped");
    
    [self setViewState:PTKAudioRecorderViewStatePreparingToSend];
    [self finishRecording];
}

- (void)cancelRecording {
    PTKLogDebug(@"Recording Canceled");
    _didCancelRecording = YES;
    
    [self setViewState:PTKAudioRecorderViewStateDefault];
    [self showWarning:nil];
    [self finishRecording];
}

- (void)finishRecording {
    [_audioRecorder stop];
    _audioRecorder = nil;
    
    [[PTKAudio sharedInstance] resignRecordWithCompletion:nil];
    [[[[UIApplication sharedApplication] delegate] window] removeGestureRecognizer:_windowTouch];
    _windowTouch = nil;
}

- (void)processRecordedFile {
    _waveform = [[PTKWaveformView alloc] initWithFrame:CGRectZero];
    _waveform.delegate = self;
    [_backgroundView addSubview:_waveform];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [_waveform renderAudioFile:_fileURL];
}

#pragma mark - VU Meter

- (void)startMeters {
    if (!_vuMeter) {
        _vuMeter = [[PTKVUMeterView alloc] initWithFrame:CGRectZero];
        _vuMeter.backgroundColor = [UIColor clearColor];
        _vuMeter.tintColor = _foregroundColor;
        [_backgroundView addSubview:_vuMeter];
    }
    
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopMeters {
    if (_displayLink) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    
    if (_vuMeter) {
        [_vuMeter removeFromSuperview];
        _vuMeter = nil;
    }
}

- (void)updateMeters {
    _duration = _audioRecorder.currentTime;
    _timeLabel.text = [PTKDatetimeUtility formattedTimeInterval:_duration];
    
    [_audioRecorder updateMeters];
    CGFloat decibels = [_audioRecorder peakPowerForChannel:0];
    if (decibels < -60.0f) decibels = 0;
    
    CGFloat level = powcg((powcg(10.0f, 0.05f * decibels) - powcg(10.0f, 0.05f * -60.0f)) * (1.0f / (1.0f - powcg(10.0f, 0.05f * -60.0f))), 1.0f / 2.0f);
    [_vuMeter updateWithLevel:level];
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    PTKLogError(@"%@", error);
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (_didCancelRecording) {
        return;
    }
    
    _fileURL = recorder.url;
    
    if (flag) {
        [self processRecordedFile];
    } else {
        [self cancelRecording];
    }
}

#pragma mark - PTKWaveformViewDelegate

- (void)waveFormView:(PTKWaveformView *)waveFormView didFinishRenderingImage:(UIImage *)image {
    [self setViewState:PTKAudioRecorderViewStateReadyToSend];
}

#pragma mark - PTKAudioPlayerDelegate

- (void)audioPlayerDidBecomeReady:(PTKAudioPlayer *)audioPlayer {
    if (!_playButton.selected) {
        [audioPlayer play];
    }
}

- (void)audioPlayer:(PTKAudioPlayer *)audioPlayer didChangeToState:(PTKPlayerState)state {
    if (state == PTKPlayerStatePlaying) {
        _playButton.selected = YES;
    } else {
        _playButton.selected = NO;
    }
}

- (void)audioPlayerDidUpdateTime:(PTKAudioPlayer *)audioPlayer {
    double progress = audioPlayer.currentTime / audioPlayer.currentDuration;
    [_waveform setProgress:progress];
}

- (void)audioPlayerDidEnd:(PTKAudioPlayer *)audioPlayer {
    [_audioPlayer stop];
    _audioPlayer = nil;
    
    [_waveform setProgress:0];
    _playButton.selected = NO;
}

@end
