//
//  PTKSpotifyImage.m
//  portkey
//
//  Created by Rodrigo Sieiro on 2/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKSpotifyImage.h"

@implementation PTKSpotifyImage

MODEL_STRING(url, @"url", nil)
MODEL_INT(width, @"width", 0)
MODEL_INT(height, @"height", 0)

+ (PTKSpotifyImage *)bestImageForSize:(CGFloat)size inImages:(NSArray*)images{
    PTKSpotifyImage *best = nil;
    
    for (PTKSpotifyImage *image in images) {
        if (!best) best = image;
        if (image.width > size && image.width < best.width) best = image;
    }
    
    return best;
}

@end
