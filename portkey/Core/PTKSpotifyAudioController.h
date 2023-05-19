//
//  PTKSpotifyAudioController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 5/11/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <Spotify/Spotify.h>

@protocol PTKSpotifyAudioControllerDelegate <NSObject>

@optional
- (NSInteger)attemptToDeliverAudioFrames:(const void *)audioFrames ofCount:(NSInteger)frameCount streamDescription:(AudioStreamBasicDescription)audioDescription;
- (uint32_t)bytesInAudioBuffer;
- (void)clearAudioBuffers;

@end

@interface PTKSpotifyAudioController : SPTCoreAudioController

@property (nonatomic, weak) id<PTKSpotifyAudioControllerDelegate> audioDelegate;

- (instancetype)initWithAudioDelegate:(id<PTKSpotifyAudioControllerDelegate>)audioDelegate;

@end
