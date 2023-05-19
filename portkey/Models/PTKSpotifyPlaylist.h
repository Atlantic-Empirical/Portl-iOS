//
//  PTKSpotifyPlaylist.h
//  portkey
//
//  Created by Rodrigo Sieiro on 2/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@class PTKSpotifyImage, PTKSpotifyTrack;
@interface PTKSpotifyPlaylist : PTKModel

- (NSString *)spotifyId;
- (BOOL)isCollaborative;
- (NSString *)playlistDescription;
- (NSString *)href;
- (NSArray<PTKSpotifyImage *> *)images;
- (NSString *)name;
- (BOOL)isPublic;
- (NSString *)snapshotId;
- (int)trackCount;
- (NSString *)type;
- (NSString *)uri;
- (NSString *)spotifyUrl;
- (NSArray<PTKSpotifyTrack *> *)tracks;

- (PTKSpotifyImage *)bestImageForSize:(CGFloat)size;

@end