//
//  NSArray+PTK.h
//  portkey
//
//  Created by Daniel Amitay on 7/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray<__covariant ObjectType> (PTK)

+ (NSArray * _Nullable) insideOutArrayWithArray:(NSArray * _Nullable) array;
- (NSMutableArray <ObjectType>* _Nonnull )mutableDeepCopy;
- (BOOL)isIdenticalToArray:(NSArray * _Nullable)other;
- (ObjectType _Nullable) safeObjectAtIndex:(NSInteger)index;

@end
