//
//  NSMutableDictionary+PTK.h
//  portkey
//
//  Created by Rodrigo Sieiro on 11/5/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (PTK)

+ (instancetype)dictionaryWithMutableDeepCopy:(NSDictionary *)dict;

- (void)removeValueForKeyPath:(NSString *)keyPath;
- (void)removeNullValues;

- (void)safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey;
- (void)safeSetValue:(id)value forKeyPath:(NSString *)keyPath;

@end
