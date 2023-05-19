//
//  PTKAudioMessage.h
//  portkey
//
//  Created by Rodrigo Sieiro on 12/8/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKMessage.h"

@interface PTKAudioMessage : PTKMessage

- (NSString *)audioUrl;
- (NSTimeInterval)duration;

- (id)copyWithAudioUrl:(NSString *)audioUrl;
- (id)copyWithDuration:(NSTimeInterval)duration;

@property (nonatomic, assign) BOOL shouldDeleteOriginals;

+ (PTKAudioMessage *)messageWithRoomId:(NSString *)roomId body:(NSString *)body originalPath:(NSString *)originalPath duration:(NSTimeInterval)duration;

@end
