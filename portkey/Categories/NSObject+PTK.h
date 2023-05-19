//
//  NSObject+PTK.h
//  portkey
//
//  Created by Daniel Amitay on 3/17/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PTK)

@property (nonatomic, strong) id associatedObject;

- (void)listenFor:(NSString *)name selector:(SEL)selector;
- (void)stopListeningFor:(NSString *)name;

@end
