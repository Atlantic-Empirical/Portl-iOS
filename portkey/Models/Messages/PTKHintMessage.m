//
//  PTKHintMessage.m
//  portkey
//
//  Created by Adam Bellard on 4/6/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKHintMessage.h"

@implementation PTKHintMessage

- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        _cachedType = PTKMessageTypeHint;
        _didCacheType = YES;
    }
    return self;
}

@end
