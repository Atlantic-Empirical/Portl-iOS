//
//  PTKChannelProtocol.h
//  portkey
//
//  Created by Rodrigo Sieiro on 6/7/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTKChannelProtocol;
@protocol PTKChannelProtocolDelegate<NSObject>

- (void)channelProtocolAddGetRequest:(PTKChannelProtocol *)channel;
- (void)channelProtocolRemoveGetRequest:(PTKChannelProtocol *)channel;
- (void)channelProtocol:(PTKChannelProtocol *)channel handleMessage:(NSDictionary *)msg forDoc:(NSString *)docId;

@end

@interface PTKChannelProtocol : NSURLProtocol

@property (nonatomic, readonly, strong) NSString *docId;

+ (void)setDelegate:(id<PTKChannelProtocolDelegate>)delegate;
+ (void)removeDelegate:(id<PTKChannelProtocolDelegate>)delegate;
- (void)sendResponseWithData:(NSData *)data;

@end
