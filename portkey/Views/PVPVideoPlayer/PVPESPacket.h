//
//  PVPESPacket.h
//  PVPHLSPlayer
//
//  Created by Rodrigo Sieiro on 25/12/16.
//  Copyright © 2016 Airtime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVPTSDefines.h"

@interface PVPESPacket : NSObject

@property (nonatomic) uint16_t pid;
@property (nonatomic) PVPTSStreamType streamType;
@property (nonatomic) uint64_t dts;
@property (nonatomic) uint64_t pts;
@property (nonatomic) uint64_t duration;
@property (nonatomic) const unsigned char *data;
@property (nonatomic) size_t size;
@property (nonatomic) const unsigned char *spsData;
@property (nonatomic) size_t spsSize;
@property (nonatomic) const unsigned char *ppsData;
@property (nonatomic) size_t ppsSize;
@property (nonatomic) BOOL isKeyframe;
@property (nonatomic) int sampleRate;
@property (nonatomic) int channels;

- (instancetype)initWithPID:(uint16_t)pid streamType:(PVPTSStreamType)streamType;

@end
