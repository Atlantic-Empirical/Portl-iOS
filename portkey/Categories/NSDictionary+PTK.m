//
//  NSDictionary+PTK.m
//  portkey
//
//  Created by Daniel Amitay on 7/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "NSDictionary+PTK.h"

@implementation NSDictionary (PTK)

- (id)valueForKeyPath:(NSString *)keyPath {
    NSArray *keys = [keyPath componentsSeparatedByString:@"."];
    NSUInteger count = [keys count];

    if (count == 1) {
        return [self valueForKey:keyPath];
    } else {
        NSDictionary *root = [self valueForKey:[keys firstObject]];

        if (root && [root isKindOfClass:[NSDictionary class]]) {
            NSString *child = [[keys subarrayWithRange:NSMakeRange(1, count - 1)] componentsJoinedByString:@"."];
            return [root valueForKeyPath:child];
        } else {
            return nil;
        }
    }
}

- (NSMutableDictionary *)mutableDeepCopy {
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] initWithCapacity:self.count];

    NSArray *keys = [self allKeys];

    for(id key in keys) {
        id oneValue = [self objectForKey:key];
        id oneCopy = nil;

        if (oneValue == [NSNull null]) {
            continue;
        }

        if([oneValue respondsToSelector:@selector(mutableDeepCopy)]) {
            oneCopy = [oneValue mutableDeepCopy];
        } else if([oneValue conformsToProtocol:@protocol(NSMutableCopying)]) {
            oneCopy = [oneValue mutableCopy];
        } else if([oneValue conformsToProtocol:@protocol(NSCopying)]){
            oneCopy = [oneValue copy];
        } else {
            oneCopy = oneValue;
        }

        [returnDict setValue:oneCopy forKey:key];
    }

    return returnDict;
}

- (BOOL)isIdenticalToDictionary:(NSDictionary *)other {
    if (!other) return NO;
    if (![other isKindOfClass:[NSDictionary class]]) return NO;
    if (self.count != other.count) return NO;

    for (id key in self.allKeys) {
        id value = [self objectForKey:key];
        id otherValue = [other objectForKey:key];
        if (value && !otherValue) return NO;

        if ([value isKindOfClass:[NSDictionary class]]) {
            BOOL result = [((NSDictionary *)value) isIdenticalToDictionary:otherValue];
            if (!result) return NO;
        } else if ([value isKindOfClass:[NSArray class]]) {
            BOOL result = [((NSArray *)value) isIdenticalToArray:otherValue];
            if (!result) return NO;
        } else {
            BOOL result = [value isEqual:otherValue];
            if (!result) return NO;
        }
    }
    
    return YES;
}


@end
