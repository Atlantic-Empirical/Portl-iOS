//
//  NSObject+PTK.m
//  portkey
//
//  Created by Daniel Amitay on 3/17/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "NSObject+PTK.h"
#import <objc/runtime.h>

static char const * const PTKAssociatedObjectKey = "PTKAssociatedObject";

@implementation NSObject (PTK)
@dynamic associatedObject;

#pragma mark - Associated properties

- (id)associatedObject {
    return objc_getAssociatedObject(self, PTKAssociatedObjectKey);
}

- (void)setAssociatedObject:(id)associatedObject {
    objc_setAssociatedObject(self, PTKAssociatedObjectKey, associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - Helper methods

- (void)listenFor:(NSString *)name selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:nil];
#ifdef DEBUG
    if (![self respondsToSelector:selector]) {
        PTKLogError(@"Object %@ does not respond to selector: %@", self, NSStringFromSelector(selector));
    }
#endif
}

- (void)stopListeningFor:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

@end
