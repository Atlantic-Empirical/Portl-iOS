//
//  PTKNetworkActivityIndicator.m
//  portkey
//
//  Created by Stanislav Nikiforov on 4/21/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKNetworkActivityIndicator.h"

@implementation PTKNetworkActivityIndicator

static int count = 0;

+ (void)ref {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (++count == 1) {
//            PTKLog(@"showing network activity indicator");
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        }
    });
}

+ (void)unref {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (--count == 0) {
//            PTKLog(@"hiding network activity indicator");
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        PTKAssert(count >= 0, @"network activity indicator ref error!");
    });
}

@end
