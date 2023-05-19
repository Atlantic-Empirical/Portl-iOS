//
//  PTKProxyProtocol.h
//  portkey
//
//  Created by Rodrigo Sieiro on 6/7/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTKProxyProtocol;
@protocol PTKProxyProtocolDelegate<NSObject>

@required
- (BOOL)proxyProtocolShouldInterceptURL:(NSURL *)url;
- (NSData *)proxyProtocol:(PTKProxyProtocol *)proxy scriptToInjectForURL:(NSURL *)url;

@end

@interface PTKProxyProtocol : NSURLProtocol <NSURLConnectionDelegate>
{
    BOOL _isHtml;
    BOOL _injectedScript;
}

@property (nonatomic, strong) NSURLConnection *connection;

+ (void)setDelegate:(id<PTKProxyProtocolDelegate>)delegate;
+ (void)removeDelegate:(id<PTKProxyProtocolDelegate>)delegate;

@end
