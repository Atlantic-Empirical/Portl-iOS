//
//  PVPESPacket.m
//  PVPHLSPlayer
//
//  Created by Rodrigo Sieiro on 25/12/16.
//  Copyright © 2016 Airtime. All rights reserved.
//

#import "PVPESPacket.h"
#import "PVPTSDefines.h"

@implementation PVPESPacket

- (instancetype)initWithPID:(uint16_t)pid streamType:(PVPTSStreamType)streamType {
    self = [super init];
    if (!self) return nil;

    _pid = pid;
    _streamType = streamType;
    _dts = TS_PTS_UNSET;
    _pts = TS_PTS_UNSET;

    return self;
}

@end
