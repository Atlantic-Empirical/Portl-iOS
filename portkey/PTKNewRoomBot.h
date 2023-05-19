//
//  PTKNewRoomBot.h
//  portkey
//
//  Created by Adam Bellard on 12/14/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PTKNewRoomBotDelegate <NSObject>

- (void)newRoomBotFinished;

@end

@interface PTKNewRoomBot : NSObject

@property (readwrite, nonatomic) BOOL hasInsertedMessages;
@property (nonatomic, weak) id<PTKNewRoomBotDelegate> delegate;

- (instancetype)initWithRoomId:(NSString *)roomId;

- (void)insertMessages;

@end
