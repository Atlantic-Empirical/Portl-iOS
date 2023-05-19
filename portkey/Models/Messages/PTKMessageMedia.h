//
//  PTKMessageMedia.h
//  portkey
//
//  Created by Rodrigo Sieiro on 23/8/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@class PTKImageInfo, PTKMessage;
@interface PTKMessageMedia : PTKModel

+ (NSArray *)mediaFromMessage:(PTKMessage *)message;

- (PTKImageInfo *)imageInfo;
- (NSString *)roomId;
- (NSString *)messageId;
- (NSInteger)imageInfoIndex;
- (PTKMessage *)message;

@end
