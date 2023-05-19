//
//  PTKAudioPageViewController.m
//  portkey
//
//  Created by Rodrigo Sieiro on 2/9/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

@import MediaPlayer;
#import "PTKAudioPageViewController.h"
#import "PTKSpotifyMessage.h"
#import "PTKSoundCloudMessage.h"
#import "PTKiHeartMessage.h"
#import "PTKSpotifyAPI.h"
#import "PTKSpotifyLoginViewController.h"
#import "PTKSpotifyResultCell.h"
#import "PTKAudioPlayer.h"
#import "PTKAudioPlayerTrack.h"
#import "PTKAudioPlayerView.h"

@interface PTKAudioPageViewController () <PTKSpotifyLoginViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, PTKAudioPlayerDelegate, PTKAudioPlayerViewDelegate, PTKImageViewDelegate> {
    UILabel *_titleLabel, *_subtitleLabel;
    UITableView *_tableView;
    PTKSpotifyLoginViewController *_loginViewController;
    UIButton *_playButton;
    BOOL _layoutForTrack;

    NSArray *_tracks;
    PTKAudioPlayer *_audioPlayer;
    PTKAudioPlayerView *_playerView;
}

@end

@implementation PTKAudioPageViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.userInteractionEnabled = YES;
    self.imageView.clipsToBounds = YES;
    self.imageView.delegate = self;

    if (self.messageMedia) {
        [self.imageView setImageWithUrl:self.messageMedia.imageInfo.imageUrl];

        PTKMessage *message = self.messageMedia.message;

        if (message.type == PTKMessageTypeSpotify) {
            PTKSpotifyMessage *spotifyMessage = (PTKSpotifyMessage *)message;
            _layoutForTrack = [spotifyMessage.spotifyType isEqualToString:@"track"];
        } else {
            _layoutForTrack = YES;
        }
    }

    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.hidden = self.shouldAutoplay;
    _playButton.frame = self.imageView.bounds;
    _playButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_playButton setImage:[UIImage imageNamed:@"alpha-play"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.imageView addSubview:_playButton];

    CGFloat imageSize = (_layoutForTrack) ? 300.0f : 135.0f;
    self.imageView.frame = CGRectMake(ceilcg(self.view.width / 2.0f) - ceilcg(imageSize / 2.0f), 60.0f, imageSize, imageSize);

    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [PTKFont boldFontOfSize:16.0f];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [PTKColor almostWhiteColor];
    _titleLabel.numberOfLines = 1;
    [self.view addSubview:_titleLabel];

    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.font = [PTKFont regularFontOfSize:11.0f];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
    _subtitleLabel.textColor = [UIColor lightGrayColor];
    _subtitleLabel.numberOfLines = 1;
    [self.view addSubview:_subtitleLabel];

    if (!_layoutForTrack) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.hidden = _layoutForTrack;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 50.0f)];

        UIEdgeInsets insets = _tableView.contentInset;
        insets.top = -50.0f;
        _tableView.contentInset = insets;
        _tableView.scrollIndicatorInsets = insets;

        [_tableView registerClass:[PTKSpotifyResultCell class] forCellReuseIdentifier:@"SpotifyCell"];
        [self.view addSubview:_tableView];
    }

    _playerView = [[PTKAudioPlayerView alloc] initWithFrame:CGRectMake(0, self.view.height - [PTKAudioPlayerView expandedSize], self.view.width, [PTKAudioPlayerView expandedSize])];
    _playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _playerView.playerState = PTKPlayerStateUnstarted;
    _playerView.delegate = self;
    [self.view addSubview:_playerView];

    [self loadAudioMetadata];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.imageView.hidden = NO;

    if (self.messageMedia && !_audioPlayer && self.shouldAutoplay) {
        [self startPlayback];
    } else if (_audioPlayer && _audioPlayer.playerState != PTKPlayerStateLoginNeeded && _audioPlayer.playerState != PTKPlayerStatePremiumRequired) {
        [_audioPlayer play];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if (_audioPlayer && _audioPlayer.playerState != PTKPlayerStateLoginNeeded && _audioPlayer.playerState != PTKPlayerStatePremiumRequired) {
        [_audioPlayer pause];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if (_audioPlayer) {
        [_audioPlayer stop];
        _audioPlayer = nil;
    }

    _playerView.currentTrack = nil;
    _playerView.playerState = PTKPlayerStateUnstarted;
    _playerView.currentTrack = [_tracks firstObject];

    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:NO];
    self.shouldAutoplay = NO;
    _playButton.hidden = NO;
}

- (void)viewDidLayoutSubviews {
    [super viewWillLayoutSubviews];

    [_titleLabel setFrame:CGRectMake(10.0f, self.imageView.maxY + 15.0f, self.view.width - 20.0f, 20.0f)];
    [_subtitleLabel setFrame:CGRectMake(10.0f, self.imageView.maxY + 35.0f, self.view.width - 20.0f, 15.0f)];

    if (!_layoutForTrack) {
        CGFloat playerSize = (_playerView && _playerView.expanded) ? [PTKAudioPlayerView expandedSize] : _playerView ? [PTKAudioPlayerView collapsedSize] : 0;
        _tableView.frame = CGRectMake(0, _subtitleLabel.maxY + 30.0f, self.view.width, self.view.height - _subtitleLabel.maxY - 30.0f - playerSize);
    }
}

#pragma mark - Custom Logic

- (void)prepareForPanning {
    self.imageView.hidden = YES;
}

- (void)loadAudioMetadata {
    PTKMessage *message = self.messageMedia.message;
    PTKMessageType type = message.type;

    if (type == PTKMessageTypeSpotify) {
        _playerView.service = PTKAudioPlayerViewServiceSpotify;

        __block PTKSpotifyMessage *spotifyMessage = (PTKSpotifyMessage *)message;
        __weak typeof(self) weakSelf = self;

        [PTKSpotifyAPI validateAndUpdateAccessTokenIfNeededWithCompletion:^(BOOL hasValidSession, NSError *error) {
            if (hasValidSession) {
                if (_loginViewController) {
                    [_loginViewController willMoveToParentViewController:nil];
                    [_loginViewController.view removeFromSuperview];
                    [_loginViewController removeFromParentViewController];
                    _loginViewController = nil;
                }

                [spotifyMessage fetchSpotifyObjectWithCompletion:^(id spotifyObject, BOOL hasData) {
                    typeof(self) strongSelf = weakSelf;
                    if (!strongSelf) return;

                    if (spotifyObject && message) {
                        if (!hasData) {
                            spotifyMessage = [spotifyMessage copyWithSpotifyObject:spotifyObject];
                            [[PTKWeakSharingManager messagesDataSourceForRoom:message.roomId] replaceObjectWithId:message.oid withObject:message completion:nil];
                        }

                        strongSelf->_tracks = [PTKSpotifyAPI tracksForSpotifyObject:spotifyObject];
                        strongSelf->_titleLabel.text = spotifyMessage.titleText;
                        strongSelf->_subtitleLabel.text = spotifyMessage.subtitleText;
                        strongSelf->_playerView.currentTrack = [strongSelf->_tracks firstObject];

                        for (PTKAudioPlayerTrack *track in _tracks) {
                            track.artwork = strongSelf.imageView.image;
                        }

                        [strongSelf->_tableView reloadData];

                        if (strongSelf.shouldAutoplay) {
                            [strongSelf startPlayback];
                        }
                    } else {
                        strongSelf->_titleLabel.text = NSLocalizedString(@"Unknown", nil);
                        strongSelf->_subtitleLabel.text = nil;
                    }
                }];
            } else {
                _playerView.playerState = PTKPlayerStateLoginNeeded;

                if (!_loginViewController) {
                    _loginViewController = [PTKSpotifyLoginViewController new];
                    [self addChildViewController:_loginViewController];
                    _loginViewController.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
                    _loginViewController.view.frame = self.view.bounds;
                    [self.view addSubview:_loginViewController.view];
                    [_loginViewController didMoveToParentViewController:self];
                    _loginViewController.delegate = self;
                }
            }
        }];

        return;
    } else if (type == PTKMessageTypeSoundCloud) {
        _playerView.service = PTKAudioPlayerViewServiceSoundcloud;

        PTKSoundCloudMessage *soundCloudMessage = (PTKSoundCloudMessage *)message;
        PTKAudioPlayerTrack *track = [[PTKAudioPlayerTrack alloc] initWithURL:[NSURL URLWithString:soundCloudMessage.streamURL] name:soundCloudMessage.title artist:soundCloudMessage.username];
        track.artwork = self.imageView.image;
        if (!track) return;

        _tracks = @[track];
        _titleLabel.text = track.name;
        _subtitleLabel.text = track.artist;
        _playerView.currentTrack = track;
    } else if (type == PTKMessageTypeiHeart) {
        _playerView.service = PTKAudioPlayerViewServiceiHeart;

        PTKiHeartMessage *iHeartMessage = (PTKiHeartMessage *)message;
        PTKAudioPlayerTrack *track = [[PTKAudioPlayerTrack alloc] initWithURL:[NSURL URLWithString:iHeartMessage.streamUrl] name:iHeartMessage.title artist:iHeartMessage.description];
        track.artwork = self.imageView.image;
        if (!track) return;

        _tracks = @[track];
        _titleLabel.text = track.name;
        _subtitleLabel.text = track.artist;
        _playerView.currentTrack = track;
    }

    if (self.shouldAutoplay) {
        [self startPlayback];
    }
}

- (void)startPlayback {
    if (_tracks.count == 0) return;
    if (!self.viewIsVisible) return;

    _playButton.hidden = YES;

    if (!_audioPlayer) {
        _audioPlayer = [[PTKAudioPlayer alloc] initWithAudioTap:NO];
        _audioPlayer.delegate = self;
    }

    PTKMessage *message = self.messageMedia.message;

    if (![message.user isSelf]) {
        // Mark message as viewed
        [PTKAPI viewMessageId:message.oid roomId:self.messageMedia.roomId callback:nil];
    }

    [_audioPlayer loadTracks:_tracks];
}

- (void)playButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(mediaPageView:hideOverlayAnimated:)]) {
        [self.delegate mediaPageView:self hideOverlayAnimated:YES];
    }

    [self startPlayback];
}

#pragma mark - PTKImageViewDelegate

- (void)imageViewDidFinishLoadingImage:(PTKImageView *)imageView {
    [_playerView setBackgroundImage:self.imageView.image baseURL:self.imageView.imageUrl];

    for (PTKAudioPlayerTrack *track in _tracks) {
        track.artwork = self.imageView.image;
    }

    _playerView.currentTrack = _playerView.currentTrack;
}

#pragma mark - PTKSpotifyLoginViewControllerDelegate

- (void)spotifyLoginViewControllerDidLogin:(PTKSpotifyLoginViewController *)spotifyLoginViewController {
    [self loadAudioMetadata];
}

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tracks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PTKSpotifyResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpotifyCell" forIndexPath:indexPath];
    PTKAudioPlayerTrack *track = _tracks[indexPath.row];
    cell.textLabel.text = track.name;
    cell.detailTextLabel.text = track.artist;
    cell.imageView.image = nil;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50.0f)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    view.backgroundColor = [UIColor clearColor];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 10.0f, view.width - 15.0f, 40.0f)];
    title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    title.font = [PTKFont mediumFontOfSize:13.0f];
    title.textColor = [UIColor lightGrayColor];
    title.text = [NSLocalizedString(@"Includes", 0) uppercaseString];
    [view addSubview:title];

    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(mediaPageView:hideOverlayAnimated:)]) {
        [self.delegate mediaPageView:self hideOverlayAnimated:YES];
    }

    if (_audioPlayer) {
        [_audioPlayer setTrackIndex:indexPath.row atSeconds:0 play:YES];
    } else {
        [self startPlayback];
    }
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if (gestureRecognizer == self.backgroundTapGesture) {
        CGPoint touchPoint = [touch locationInView:self.view];
        CGRect frame = _tableView.frame;
        return !CGRectContainsPoint(frame, touchPoint);
    }

    return YES;
}

#pragma mark - PTKAudioPlayerDelegate

- (void)audioPlayerDidBecomeReady:(PTKAudioPlayer *)audioPlayer {
    NSIndexPath *indexPath = [_tableView indexPathForSelectedRow];
    [_audioPlayer setTrackIndex:indexPath.row atSeconds:0 play:YES];
}

- (void)audioPlayer:(PTKAudioPlayer *)audioPlayer willLoadTrack:(PTKAudioPlayerTrack *)track {
    _playerView.currentTrack = track;
}

- (void)audioPlayer:(PTKAudioPlayer *)audioPlayer didLoadTrack:(PTKAudioPlayerTrack *)track userAction:(BOOL)userAction {
    _playerView.currentTrack = track;

    if (!_layoutForTrack) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:audioPlayer.currentTrackIndex inSection:0];
        [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)audioPlayer:(PTKAudioPlayer *)audioPlayer didChangeToState:(PTKPlayerState)state {
    _playerView.playerState = state;
}

- (void)audioPlayer:(PTKAudioPlayer *)audioPlayer didUpdateLoadedTimeRanges:(NSArray *)loadedTimeRanges {
    [_playerView updateLoadedTimeRanges:loadedTimeRanges];
}

- (void)audioPlayerDidUpdateTime:(PTKAudioPlayer *)audioPlayer {
    _playerView.currentTime = audioPlayer.currentTime;
}

- (void)audioPlayer:(PTKAudioPlayer *)audioPlayer didFailWithError:(NSError *)error {
    [self showAlertWithTitle:@"Playback Error" andMessage:error.localizedDescription];
}

#pragma mark - PTKAudioPlayerViewDelegate

- (void)audioPlayerViewDidLogin:(PTKAudioPlayerView *)audioPlayerView {
    _audioPlayer = nil;
    [self startPlayback];
}

- (void)audioPlayerViewDidPause:(PTKAudioPlayerView *)audioPlayerView {
    [_audioPlayer pause];
}

- (void)audioPlayerViewDidPlay:(PTKAudioPlayerView *)audioPlayerView {
    if (_audioPlayer) {
        [_audioPlayer play];
    } else {
        [self startPlayback];
    }
}

- (void)audioPlayerViewDidSkipNext:(PTKAudioPlayerView *)audioPlayerView {
    [_audioPlayer nextTrack];
}

- (void)audioPlayerViewDidSkipPrevious:(PTKAudioPlayerView *)audioPlayerView {
    [_audioPlayer previousTrack];
}

- (void)audioPlayerView:(PTKAudioPlayerView *)audioPlayerView didSeekToSeconds:(double)seconds {
    [_audioPlayer seekToSeconds:seconds];
}

@end
