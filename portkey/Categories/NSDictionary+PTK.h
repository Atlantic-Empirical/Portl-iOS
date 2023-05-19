//
//  NSDictionary+PTK.h
//  portkey
//
//  Created by Daniel Amitay on 7/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (PTK)

- (id)valueForKeyPath:(NSString *)keyPath;
- (NSMutableDictionary *)mutableDeepCopy;
- (BOOL)isIdenticalToDictionary:(NSDictionary *)other;

@end
