//
//  PTKMessagesDataSource.h
//  portkey
//
//  Created by Daniel Amitay on 5/8/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKInfoMessage.h"
#import "PTKMessage.h"
#import "PTKPaginatedDataSource.h"

@interface PTKMessagesDataSource : PTKPaginatedDataSource

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy) NSMutableArray *fakeMessages;
@property (nonatomic) PTKMessage *mostRecentPresenceInfoMessage;
@property (nonatomic, strong) NSDate *lastSeenMessageDate;
@property (nonatomic, readwrite) BOOL shouldUpdateLastSeenMessageDateOnNewMessage;

- (instancetype)initWithRoomId:(NSString *)roomId limit:(NSUInteger)limit;
- (void)insertFakeMessage:(PTKMessage *)message;
- (void)removeFakeMessage:(PTKMessage *)message;
- (void)fetchAndAddMessageWithId:(NSString *)messageId completion:(void(^)())completion;

@end
