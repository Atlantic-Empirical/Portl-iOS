//
//  PVPHLSSegment.m
//  PTKHLSPlayer
//
//  Created by Rodrigo Sieiro on 11/1/17.
//  Copyright © 2017 Airtime. All rights reserved.
//

#import "PVPHLSSegment.h"

@implementation PVPHLSSegment

- (instancetype)initWithSequence:(NSUInteger)sequence url:(NSURL *)url duration:(double)duration {
    self = [super init];
    if (!self) return nil;

    _sequence = sequence;
    _url = url;
    _name = [url lastPathComponent];
    _duration = duration;

    return self;
}

#pragma mark - Equality

- (NSUInteger)hash {
    return self.sequence;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    } else if (![object isKindOfClass:[self class]] && ![self isKindOfClass:[object class]]) {
        return NO;
    }

    PVPHLSSegment *other = (PVPHLSSegment *)object;
    return self.sequence == other.sequence;
}


@end
