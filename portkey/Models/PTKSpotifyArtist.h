//
//  PTKSpotifyArtist.h
//  portkey
//
//  Created by Rodrigo Sieiro on 2/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@class PTKSpotifyImage;
@interface PTKSpotifyArtist : PTKModel

- (NSString *)spotifyId;
- (NSArray *)genres;
- (NSString *)href;
- (NSArray<PTKSpotifyImage *> *)images;
- (NSString *)name;
- (int)popularity;
- (NSString *)type;
- (NSString *)uri;
- (NSString *)spotifyUrl;

- (PTKSpotifyImage *)bestImageForSize:(CGFloat)size;

@end
