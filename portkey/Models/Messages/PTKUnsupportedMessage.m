//
//  PTKUnsupportedMessage.m
//  portkey
//
//  Created by Rodrigo Sieiro on 10/7/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKUnsupportedMessage.h"

@implementation PTKUnsupportedMessage

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        _cachedType = PTKMessageTypeUnsupported;
        _didCacheType = YES;
    }
    return self;
}

@end
