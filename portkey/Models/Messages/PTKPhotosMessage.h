//
//  PTKPhotosMessage.h
//  portkey
//
//  Created by Stanislav Nikiforov on 4/20/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKMessage.h"

@interface PTKPhotosMessage : PTKMessage

- (NSArray *)imageInfos;
- (id)copyWithImageInfos:(NSArray *)imageInfos;

// Non-serialized properties
@property (nonatomic, strong) NSArray *placeholderThumbnails;
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic) BOOL isGiphy;
@property (nonatomic) BOOL fromCamera; // To check if from camera or camera roll when reporting

+ (PTKPhotosMessage *)messageWithRoomId:(NSString *)roomId body:(NSString *)body imageInfos:(NSArray *)imageInfos;
+ (PTKPhotosMessage *)giphyMessageWithRoomId:(NSString *)roomId body:(NSString *)body imageInfos:(NSArray *)imageInfos;
+ (PTKPhotosMessage *)messageWithRoomId:(NSString *)roomId body:(NSString *)body images:(NSArray *)images assets:(NSArray *)assets;

@end
