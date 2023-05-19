//
//  NSArray+PTK.m
//  portkey
//
//  Created by Daniel Amitay on 7/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "NSArray+PTK.h"

@implementation NSArray (PTK)

- (NSMutableArray *)mutableDeepCopy
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:self.count];

    for(id oneValue in self) {
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

        [returnArray addObject:oneCopy];
    }

    return returnArray;
}

- (BOOL)isIdenticalToArray:(NSArray *)other {
    if (!other) return NO;
    if (![other isKindOfClass:[NSArray class]]) return NO;
    if (self.count != other.count) return NO;

    NSEnumerator *otherEnumerator = other.objectEnumerator;

    for (id value in self) {
        id otherValue = [otherEnumerator nextObject];

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

+ (NSArray*) insideOutArrayWithArray:(NSArray*) array {
    if (array.count < 3) {
        return array;
    }
    
    NSMutableArray *newArray = [array mutableCopy];
    
    //For an odd number of elements
    //    0 1 2 3 4
    //    3 1 0 2 4
    
    //For an even number of elements
    //    0 1 2 3 4 5
    //    4 2 0 1 3 5
    int midpoint = (int)ceil(array.count / 2) - 1 + (array.count % 2);
    
    int i = 0;
    
    if (array.count % 2 == 1) {
        //For odd under of presences add first element to midpoint
        // then continue as normal
        newArray[midpoint] = array[0];
        i++;
    }
    
    for (  ; i <= midpoint; i++) {
        newArray[midpoint - i] = array[i*2 - (array.count % 2)];
        newArray[midpoint + 1 + i - (array.count % 2)] = array[i*2 - (array.count % 2) + 1];
    }
    
    return [NSArray arrayWithArray:newArray];
}

- (id)safeObjectAtIndex:(NSInteger)index {
    if (index < 0) {
        return nil;
    }
    if (index >= self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end
