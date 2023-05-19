//
//  PTKVimeoMessage.h
//  portkey
//
//  Created by Kay Vink on 23/11/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import "PTKMessage.h"

@interface PTKVimeoMessage : PTKMessage

- (NSString *)title;
- (NSString *)imageUrl;
- (NSString *)textDescription;
- (NSString *)vimeoID;
- (NSString *)videoUrl;

+ (PTKVimeoMessage *)messageWithRoomId:(NSString *)roomId json:(NSDictionary *)json;

@end