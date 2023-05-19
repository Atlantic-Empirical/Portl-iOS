//
//  PVPBitstream.h
//  PVPHLSPlayer
//
//  Created by Rodrigo Sieiro on 23/12/16.
//  Copyright © 2016 Airtime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVPBitstream : NSObject

@property (readonly) size_t size;
@property (readonly) BOOL hasError;

- (instancetype)initWithData:(uint8_t *)data size:(size_t)size;
- (void)skipBits:(unsigned int)bits;
- (unsigned int)readBits:(int)bits;

@end
