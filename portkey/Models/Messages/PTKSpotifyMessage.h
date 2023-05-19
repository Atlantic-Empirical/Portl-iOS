//
//  PTKSpotifyMessage.h
//  portkey
//
//  Created by Rodrigo Sieiro on 2/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKMessage.h"

@class PTKSpotifyImage;
@interface PTKSpotifyMessage : PTKMessage

- (NSString *)url;
- (NSString *)originalUrl;
- (NSString *)spotifyType;
- (NSString *)uri;
- (NSString *)name;
- (NSString *)artist;
- (NSArray *)images;
- (int)trackCount;

- (id)copyWithSpotifyObject:(id)spotifyObject;

+ (PTKSpotifyMessage *)messageWithRoomId:(NSString *)roomId body:(NSString *)body spotifyObject:(id)object;

// Helpers
- (BOOL)shouldUpdateSpotifyData;
- (NSString *)titleText;
- (NSString *)subtitleText;
- (PTKSpotifyImage *)bestImageForSize:(CGFloat)size;
- (void)fetchSpotifyObjectWithCompletion:(void(^)(id spotifyObject, BOOL hasData))completion;

@end
