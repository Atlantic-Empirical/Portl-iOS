//
//  PTKPagingLayoutAttributes.m
//  portkey
//
//  Created by Rodrigo Sieiro on 9/9/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKPagingLayoutAttributes.h"

@implementation PTKPagingLayoutAttributes

- (id)copyWithZone:(NSZone *)zone {
    PTKPagingLayoutAttributes *copy = [super copyWithZone:zone];
    copy.distanceToCenter = self.distanceToCenter;

    return copy;
}

- (BOOL)isEqual:(id)object {
    if (object == self) return YES;
    if (!object || ![object isKindOfClass:[self class]]) return NO;
    if ([self distanceToCenter] != [object distanceToCenter]) return NO;

    return [super isEqual:object];
}

@end
