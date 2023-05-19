//
//  PTKURLInterceptor.h
//  portkey
//
//  Created by Rodrigo Sieiro on 15/6/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTKURLInterceptor;
@protocol PTKURLInterceptorDelegate<NSObject>

- (BOOL)urlInterceptorShouldInterceptURL:(NSURL *)url;

@end

@interface PTKURLInterceptor : NSURLProtocol

+ (void)setDelegate:(id<PTKURLInterceptorDelegate>)delegate;
+ (void)removeDelegate:(id<PTKURLInterceptorDelegate>)delegate;

@end
