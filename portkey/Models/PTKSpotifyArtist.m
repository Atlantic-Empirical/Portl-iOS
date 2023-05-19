//
//  PTKSpotifyArtist.m
//  portkey
//
//  Created by Rodrigo Sieiro on 2/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKSpotifyArtist.h"
#import "PTKSpotifyImage.h"

@implementation PTKSpotifyArtist

MODEL_STRING(spotifyId, @"id", nil)
MODEL_ARRAY(genres, @"genres", NSString)
MODEL_STRING(href, @"href", nil)
MODEL_ARRAY(images, @"images", PTKSpotifyImage)
MODEL_STRING(name, @"name", nil)
MODEL_INT(popularity, @"popularity", 0)
MODEL_STRING(type, @"type", nil)
MODEL_STRING(uri, @"uri", nil)
MODEL_STRING(spotifyUrl, @"external_urls.spotify", nil)

- (PTKSpotifyImage *)bestImageForSize:(CGFloat)size {
    PTKSpotifyImage *best = nil;

    for (PTKSpotifyImage *image in self.images) {
        if (!best) best = image;
        if (image.width > size && image.width < best.width) best = image;
    }

    return best;
}

@end
