//
//  PTKTwitchMessage.h
//  portkey
//
//  Created by Samuel Beek on 17/06/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKMessage.h"

@interface PTKTwitchMessage : PTKMessage

- (NSString *)title;
- (NSString *)displayName;
- (NSString *)game;
- (NSString *)imageUrl;
- (NSString *)twitchType;
- (NSString *)videoId;
- (NSString *)status;
- (NSString *)videoUrl;

+ (PTKTwitchMessage *)messageWithRoomId:(NSString *)roomId json:(NSDictionary *)json;

@end
