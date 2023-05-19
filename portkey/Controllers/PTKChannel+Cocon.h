//
//  PTkChannel+Cocon.h
//  portkey
//
//  Created by Nick Galasso on 2/8/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKChannel.h"

@interface PTKChannel (Coconsumption)

-(void)emitMediaPreparingForRoom:(NSString*)roomId message:(NSString*)messageId position:(NSNumber*)position track:(NSNumber*)track;

-(void)emitMediaReadyForRoom:(NSString*)roomId message:(NSString*)messageId position:(NSNumber*)position track:(NSNumber*)track;

@end

static NSString* const kMediaPreparePayloadKey = @"kMediaPreparePayloadKey";
static NSString* const kMediaSyncPayloadKey = @"kMediaSyncPayloadKey";

@interface PTKMediaPreparePayload : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *room;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) NSNumber *updatedAt;
@property (nonatomic, strong) NSString *presenterId;
@property (nonatomic, strong) NSString *sentAt;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *control;
@property (nonatomic, strong) NSNumber *track;

-(instancetype)initWithData:(NSDictionary*)data;

@end

@interface PTKMediaSyncPayload : NSObject

@property (nonatomic, strong) NSString *control;
@property (nonatomic, strong) NSNumber *position;
@property (nonatomic, strong) NSArray *preparing;
@property (nonatomic, strong) NSArray *present;
@property (nonatomic, strong) NSArray *ready;
@property (nonatomic, strong) NSString *room;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSNumber *timeout;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSNumber *track;
@property (nonatomic, strong) NSString *user;

-(instancetype)initWithData:(NSDictionary*)data;

@end
