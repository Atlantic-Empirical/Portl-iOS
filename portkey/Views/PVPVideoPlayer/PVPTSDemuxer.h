//
//  PVPTSDemuxer.h
//  PVPHLSPlayer
//
//  Created by Rodrigo Sieiro on 22/12/16.
//  Copyright © 2016 Airtime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVPTSDefines.h"
#import "PVPStream.h"

@interface PVPTSDemuxer : NSObject

@property (nonatomic, weak) id<PVPStreamDelegate> delegate;
@property (readonly) BOOL videoEnabled;
@property (readonly) BOOL audioEnabled;

+ (PVPTSStreamType)streamTypeForPESType:(uint8_t)pesType;
- (instancetype)initWithVideoEnabled:(BOOL)videoEnabled audioEnabled:(BOOL)audioEnabled;
- (void)parseData:(NSData *)data;
- (void)flushBuffer;

@end
