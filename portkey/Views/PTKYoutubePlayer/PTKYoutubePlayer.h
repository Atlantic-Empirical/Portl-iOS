//
//  PTKYoutubePlayer.h
//  portkey
//
//  Created by Rodrigo Sieiro on 6/7/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKVideoPlayer.h"

FOUNDATION_EXPORT NSString *const PTKYoutubePlayerErrorDomain;

typedef NS_ENUM(NSInteger, YTPlayerError) {
    kYTPlayerErrorInvalidParam,
    kYTPlayerErrorHTML5Error,
    kYTPlayerErrorVideoNotFound,
    kYTPlayerErrorNotEmbeddable,
    kYTPlayerErrorUnknown
};

@interface PTKYoutubePlayer : PTKVideoPlayer

@property (nonatomic, assign) BOOL isReady;

- (BOOL)loadVideoId:(NSString *)videoId playerVars:(NSDictionary *)playerVars;

@end
