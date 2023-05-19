//
//  PTKLinkMessage.h
//  portkey
//
//  Created by Stanislav Nikiforov on 4/20/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKMessage.h"

@interface PTKLinkMessage : PTKMessage

- (NSString *)url;
- (NSString *)originalUrl;
- (NSString *)pageTitle;
- (NSString *)pageDescription;
- (NSString *)pageType;
- (NSString *)siteName;
- (NSString *)siteHost;
- (NSString *)faviconUrl;
- (NSString *)imageUrl;
- (NSString *)sharedRoomId;
- (int)imageHeight;
- (int)imageWidth;
- (NSString *)videoUrl;
- (int)videoHeight;
- (int)videoWidth;

- (BOOL)isInstagram;
- (BOOL)isTwitter;

+ (PTKLinkMessage *)messageWithRoomId:(NSString *)roomId body:(NSString *)body url:(NSString *)url;
+ (PTKLinkMessage *)messageWithRoomId:(NSString *)roomId body:(NSString *)body metadata:(NSDictionary *)metadata;

@end
