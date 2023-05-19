//
//  PTKVideoMessage.h
//  portkey
//
//  Created by Stanislav Nikiforov on 4/20/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKMessage.h"

@interface PTKVideoMessage : PTKMessage

- (NSString *)videoUrl;
- (NSTimeInterval)duration;
- (NSString *)thumbnailUrl;
- (NSString *)optimizedThumbnailUrl;
- (CGSize)thumbnailSize;

- (id)copyWithVideoUrl:(NSString *)videoUrl;
- (id)copyWithThumbnailUrl:(NSString *)thumbnailUrl;
- (id)copyWithDuration:(NSTimeInterval)duration;

@property (nonatomic, assign) BOOL fromCamera; // To check if from camera or camera roll when reporting
@property (nonatomic, assign) BOOL shouldDeleteOriginals;
@property (nonatomic, strong) NSArray *assets;

+ (PTKVideoMessage *)messageWithRoomId:(NSString *)roomId body:(NSString *)body image:(UIImage *)image originalPath:(NSString *)originalPath duration:(NSTimeInterval)duration;

@end
