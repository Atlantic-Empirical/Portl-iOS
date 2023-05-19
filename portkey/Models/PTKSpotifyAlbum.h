//
//  PTKSpotifyAlbum.h
//  portkey
//
//  Created by Rodrigo Sieiro on 2/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@class PTKSpotifyImage, PTKSpotifyArtist, PTKSpotifyTrack;
@interface PTKSpotifyAlbum : PTKModel

- (NSString *)spotifyId;
- (NSString *)albumType;
- (NSArray<PTKSpotifyArtist *> *)artists;
- (NSArray *)availableMarkets;
- (NSArray *)genres;
- (NSString *)href;
- (NSArray<PTKSpotifyImage *> *)images;
- (NSString *)name;
- (int)popularity;
- (NSString *)releaseDate;
- (NSString *)releaseDatePrecision;
- (int)trackCount;
- (NSArray<PTKSpotifyTrack *> *)tracks;
- (NSString *)type;
- (NSString *)uri;
- (NSString *)spotifyUrl;

- (PTKSpotifyImage *)bestImageForSize:(CGFloat)size;

@end
