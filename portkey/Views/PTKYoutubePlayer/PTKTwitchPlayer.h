//
//  PTKTwitchPlayer.h
//  portkey
//
//  Created by Rodrigo Sieiro on 14/6/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKVideoPlayer.h"

@interface PTKTwitchPlayer : PTKVideoPlayer

- (BOOL)loadChannel:(NSString *)channel;
- (BOOL)loadVideoId:(NSString *)videoId;

@end
