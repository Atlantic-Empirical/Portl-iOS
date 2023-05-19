//
//  PTKAudioPlayerTrack.h
//  portkey
//
//  Created by Rodrigo Sieiro on 15/10/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKAudioPlayerTrack : NSObject

@property (nonatomic, copy) NSURL *url;
@property (nonatomic, copy) NSURL *spotifyURI;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *collection;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) UIImage *artwork;

- (instancetype)initWithURL:(NSURL *)url name:(NSString *)name artist:(NSString *)artist;
- (instancetype)initWithURL:(NSURL *)url name:(NSString *)name artist:(NSString *)artist collection:(NSString *)collection;
- (instancetype)initWithSpotifyURI:(NSURL *)uri name:(NSString *)name artist:(NSString *)artist collection:(NSString *)collection;

@end
