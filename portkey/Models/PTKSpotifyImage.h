//
//  PTKSpotifyImage.h
//  portkey
//
//  Created by Rodrigo Sieiro on 2/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@interface PTKSpotifyImage : PTKModel

- (NSString *)url;
- (int)width;
- (int)height;

+ (PTKSpotifyImage *)bestImageForSize:(CGFloat)size inImages:(NSArray *)images;

@end
