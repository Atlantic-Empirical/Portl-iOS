//
//  NSMutableDictionary+PTK.m
//  portkey
//
//  Created by Rodrigo Sieiro on 11/5/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "NSMutableDictionary+PTK.h"

@implementation NSMutableDictionary (PTK)

+(instancetype)dictionaryWithMutableDeepCopy:(NSDictionary *)dict
{
    NSMutableDictionary *mutable = [NSMutableDictionary dictionaryWithCapacity:dict.count];

    for (id<NSCopying> key in [dict allKeys]) {
        if ([dict[key] isKindOfClass:[NSDictionary class]]) {
            mutable[key] = [NSMutableDictionary dictionaryWithMutableDeepCopy:dict[key]];
        } else {
            mutable[key] = dict[key];
        }
    }
    
    return mutable;
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath
{
	NSArray *keys = [keyPath componentsSeparatedByString:@"."];
	if (keys.count > 1 && ![self valueForKey:[keys firstObject]]) {
		[self setValue:[NSMutableDictionary dictionary] forKey:[keys firstObject]];
	}

	[super setValue:value forKeyPath:keyPath];
}

- (void)removeValueForKeyPath:(NSString *)keyPath
{
	NSArray *keys = [keyPath componentsSeparatedByString:@"."];
	NSUInteger count = [keys count];

	if (count == 1) {
		[self removeObjectForKey:keyPath];
	} else {
		NSString *parentKey = nil;
		NSMutableDictionary *parent = nil;

		for (int i = 1; i < count; i++) {
			parentKey = [[keys subarrayWithRange:NSMakeRange(0, count - i)] componentsJoinedByString:@"."];
			parent = [self valueForKeyPath:parentKey];
			if ([parent isKindOfClass:[NSMutableDictionary class]]) {
				[parent removeObjectForKey:keys[count - i]];
				if (parent.count > 0) break;
			}
		}

		if (parent && parent.count == 0) {
			[self removeObjectForKey:parentKey];
		}
	}
}

- (void)removeNullValues
{
	NSArray *keys = [self allKeys];

	for (NSString *key in keys) {
		if ([[NSNull null] isEqual:self[key]]) {
			[self removeObjectForKey:key];
		} else if ([self[key] isKindOfClass:[NSMutableDictionary class]]) {
			[self[key] removeNullValues];
		}
	}

}

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
}

- (void)safeSetValue:(id)value forKeyPath:(NSString *)keyPath {
    if (value && keyPath) {
        [self setValue:value forKeyPath:keyPath];
    }
}

@end
