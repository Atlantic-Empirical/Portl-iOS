//
//  PTKSpotifyTrack.h
//  portkey
//
//  Created by Rodrigo Sieiro on 2/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@class PTKSpotifyAlbum, PTKSpotifyArtist;
@interface PTKSpotifyTrack : PTKModel

- (NSString *)spotifyId;
- (PTKSpotifyAlbum *)album;
- (NSArray<PTKSpotifyArtist *> *)artists;
- (NSArray *)availableMarkets;
- (int)discNumber;
- (int)durationMs;
- (BOOL)isExplicit;
- (NSString *)href;
- (BOOL)isPlayable;
- (NSString *)name;
- (int)popularity;
- (NSString *)previewUrl;
- (int)trackNumber;
- (NSString *)type;
- (NSString *)uri;
- (NSString *)spotifyUrl;

@end
