//
//  PTKChannel+Cocon.m
//  portkey
//
//  Created by Nick Galasso on 2/8/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKChannel+Cocon.h"

@implementation PTKChannel (Coconsumption)

-(void)emitMediaPreparingForRoom:(NSString*)roomId message:(NSString*)messageId position:(NSNumber*)position track:(NSNumber*)track{
    
    WEAK_ASSERT((roomId && messageId && position), nil);
    
    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    d[kKeyRoomId] = roomId;
    d[kKeyMessageId] = messageId;
    d[kKeyPosition] = position;
    
    if (track){
        d[kKeyPayload] = @{@"track":track};
    }
    
    [[PTKChannel sharedInstance] sendEvent:@"media-preparing" withItem:d];
    
}

-(void)emitMediaReadyForRoom:(NSString*)roomId message:(NSString*)messageId position:(NSNumber*)position track:(NSNumber*)track{
    
    WEAK_ASSERT((roomId && messageId && position), nil);
    
    NSMutableDictionary *d = [[NSMutableDictionary alloc] initWithCapacity:4];
    
    d[kKeyRoomId] = roomId;
    d[kKeyMessageId] = messageId;
    d[kKeyPosition] = position;
    
    if (track){
        d[kKeyPayload] = @{@"track":track};
    }
    
    [[PTKChannel sharedInstance] sendEvent:@"media-ready" withItem:d];
    
}

@end

static NSDictionary* sanitizeDict(NSDictionary*dict){
    NSMutableDictionary *mut = [dict mutableCopy];
    for (id<NSCoding>key in [mut allKeys]){
        if (mut[key] == [NSNull null]){
            [mut removeObjectForKey:key]; 
        }
    }
    return mut;
}

static NSArray* sanitizeArray(NSArray*array){
    NSMutableArray *mut = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (id obj in array){
        if (obj != [NSNull null]){
            [mut addObject:obj];
        }
    }
    return mut;
}

@implementation PTKMediaSyncPayload

-(id)initWithData:(NSDictionary *)dict{
    self = [super init];
    if (self){
        NSDictionary *data = sanitizeDict(dict);
        _control = data[kKeyControl];
        _position = data[kKeyPosition];
        _status = data[kKeyStatus];
        _ready = sanitizeArray(data[kKeyReady]);
        _room = data[kKeyRoom];
        _preparing = sanitizeArray(data[kKeyPreparing]);
        _timeout = data[kKeyTimeoutMs];
        _present = sanitizeArray(data[kKeyPresent]);
        _message = data[kKeyMessage];
        _user = data[kKeyUser];
        
        if (data[kKeyPayload]!=[NSNull null] && [data[kKeyPayload] isKindOfClass:[NSDictionary class]]){
            NSDictionary *p = sanitizeDict(data[kKeyPayload]);
            _track = p[kKeyTrack];
        }
    }
    return self;
}

@end

@implementation PTKMediaPreparePayload

-(id)initWithData:(NSDictionary *)dict{
    self = [super init];
    if (self){
        NSDictionary *data = sanitizeDict(dict);
        _action = data[kKeyAction];
        _position = data[kKeyPosition];
        _message = data[kKeyMessage];
        _presenterId = data[kKeyPresenterId];
        _room = data[kKeyRoom];
        _user = data[kKeyUser];
        _type = data[kKeyType];
        _control = data[kKeyControl];
        
        if (data[kKeyPayload]!=[NSNull null] && [data[kKeyPayload] isKindOfClass:[NSDictionary class]]){
            NSDictionary *p = sanitizeDict(data[kKeyPayload]);
            _track = p[kKeyTrack];
        }
    }
    return self;
}

@end
