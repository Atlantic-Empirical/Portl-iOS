//
//  PTKYoutubeMessage.h
//  portkey
//
//  Created by Stanislav Nikiforov on 4/20/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKMessage.h"

@interface PTKYoutubeMessage : PTKMessage

- (NSString *)url;
- (NSString *)originalUrl;
- (NSString *)siteName;
- (NSString *)title;
- (NSString *)imageUrl;
- (NSString *)textDescription;
- (NSString *)youtubeId;

+ (PTKYoutubeMessage *)messageWithRoomId:(NSString *)roomId body:(NSString *)body url:(NSString *)url title:(NSString *)title imageUrl:(NSString *)imageUrl description:(NSString *)description source:(NSString *)source;

@end
