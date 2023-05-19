//
//  PTKTextMessage.h
//  portkey
//
//  Created by Stanislav Nikiforov on 4/20/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKMessage.h"

@interface PTKTextMessage : PTKMessage

+ (PTKTextMessage *)messageWithRoomId:(NSString *)roomId body:(NSString *)body;
+ (PTKTextMessage *)messageWithExistingId:(NSString *)existingId roomId:(NSString *)roomId body:(NSString *)body;

@end
