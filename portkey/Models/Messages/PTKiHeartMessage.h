//
//  PTKiHeartMessage.h
//  portkey
//
//  Created by Kay Vink on 05/10/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import "PTKMessage.h"

@interface PTKiHeartMessage : PTKMessage

- (NSString *)streamUrl;
- (NSString *)title;
- (NSString *)description;
- (NSString *)logoUrl;

+ (PTKiHeartMessage *)messageWithRoomId:(NSString *)roomId title:(NSString *)title description:(NSString *)description streamUrl:(NSString *)streamUrl logoUrl:(NSString *)logoUrl;

@end
