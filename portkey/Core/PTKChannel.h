//
//  PTKChannel.h
//  portkey
//
//  Created by Stanislav Nikiforov on 4/22/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

typedef NS_ENUM(NSInteger, PTKChannelState) {
    PTKChannelStateNotConnected,
    PTKChannelStateConnecting,
    PTKChannelStateConnected
};


@interface PTKChannel : NSObject

@property (nonatomic, assign) BOOL shouldRemainConnected;

+ (PTKChannel *)sharedInstance;
- (PTKChannelState)state;
- (BOOL)isHealthy;

#pragma mark - Event sending methods

- (BOOL)sendEvent:(NSString *)event withItem:(id)item;
- (BOOL)sendEvent:(NSString *)event withItem:(id)item withCallback:(void (^)(NSError *error, id data))callback;
- (BOOL)sendEvent:(NSString *)event withItem:(id)item withTimeout:(uint64_t)timeout withCallback:(void (^)(NSError *error, id data))callback;

- (void)enterRoom:(NSString *)roomId;
- (void)leaveRoom:(NSString *)roomId;

@end
