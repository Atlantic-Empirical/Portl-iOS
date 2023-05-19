//
//  PTKPlayerControls.h
//  portkey
//
//  Created by Rodrigo Sieiro on 9/7/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKPlayerControls;
@protocol PTKPlayerControlsDelegate <NSObject>

@required
- (void)playerControlsDidPlay:(PTKPlayerControls *)playerControls;
- (void)playerControlsDidPause:(PTKPlayerControls *)playerControls;
- (void)playerControls:(PTKPlayerControls *)playerControls didSeekToSeconds:(double)seconds;
- (void)playerControls:(PTKPlayerControls *)playerControls didShowControls:(BOOL)show automatic:(BOOL)automatic;

@end

@interface PTKPlayerControls : UIView

@property (nonatomic, weak) id<PTKPlayerControlsDelegate> delegate;
@property (nonatomic, assign) PTKPlayerState playerState;
@property (nonatomic, assign) double duration;
@property (nonatomic, assign) double currentTime;

- (void)updateLoadedTime:(double)loadedTime;

@end
