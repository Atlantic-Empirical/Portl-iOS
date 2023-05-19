//
//  PTKProtocolInterceptor.h
//  portkey
//
//  Created by Rodrigo Sieiro on 11/5/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKProtocolInterceptor : NSObject

@property (nonatomic, readonly, copy) NSArray * interceptedProtocols;
@property (nonatomic, weak) id receiver;
@property (nonatomic, weak) id middleMan;

- (instancetype)initWithInterceptedProtocol:(Protocol *)interceptedProtocol;
- (instancetype)initWithInterceptedProtocols:(Protocol *)firstInterceptedProtocol, ... NS_REQUIRES_NIL_TERMINATION;
- (instancetype)initWithArrayOfInterceptedProtocols:(NSArray *)arrayOfInterceptedProtocols;

@end
