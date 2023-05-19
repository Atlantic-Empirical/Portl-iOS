//
//  PTKReferenceCounter.h
//  portkey
//
//  Created by Daniel Amitay on 9/22/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const PTKReferenceCounterDidChange; // UserInfo will contain a PTKReferenceKey key
FOUNDATION_EXPORT NSString *const PTKReferenceKey;

@interface PTKReferenceCounter : NSObject

+ (PTKReferenceCounter *)sharedInstance;

- (void)increment:(NSString *)reference;
- (void)increment:(NSString *)reference by:(NSInteger)count;
- (void)decrement:(NSString *)reference;
- (void)decrement:(NSString *)reference by:(NSInteger)count;

- (NSInteger)get:(NSString *)reference;
- (void)set:(NSString *)reference to:(NSInteger)count;
- (void)zero:(NSString *)reference;

@end
