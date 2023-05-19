//
//  PTKHLSMessage.h
//  portkey
//
//  Created by Samuel Beek on 3/8/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKMessage.h"

@interface PTKHLSMessage : PTKMessage


- (NSString *)url;
- (NSString *)originalUrl;
- (NSString *)videoUrl;
- (NSString *)title;
- (NSString *)textDescription;
- (NSString *)domainString;

+ (PTKHLSMessage *)messageWithRoomId:(NSString *)roomId body:(NSString *)body url:(NSString *)url title:(NSString *)title description:(NSString *)description;

@end
