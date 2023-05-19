//
//  PVPDynamicBuffer.h
//  PVPHLSPlayer
//
//  Created by Rodrigo Sieiro on 27/12/16.
//  Copyright © 2016 Airtime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVPDynamicBuffer : NSObject

@property (readonly) unsigned char *data;
@property (readonly) size_t size;
@property (nonatomic) size_t offset;

- (instancetype)initWithMinimumSize:(size_t)minimumSize maximumSize:(size_t)maximumSize;
- (BOOL)appendData:(const unsigned char *)data size:(size_t)size;
- (void)reset;

@end
