//
//  PTKSoundCloudMessage.h
//  portkey
//
//  Created by Samuel Beek on 23/09/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import "PTKMessage.h"

@interface PTKSoundCloudMessage : PTKMessage

- (NSString *)url;
- (NSString *)streamURL;
- (NSString *)siteName;
- (NSString *)username;
- (NSString *)title;
- (int)playCount;
- (NSString *)imageUrl;

+ (PTKSoundCloudMessage *)messageWithRoomId:(NSString *)roomId body:(NSString *)body url:(NSString *)url  streamURL:(NSString *)streamURL title:(NSString *)title imageUrl:(NSString *)imageUrl username:(NSString *)username playCount:(NSNumber *)playCount;

@end
