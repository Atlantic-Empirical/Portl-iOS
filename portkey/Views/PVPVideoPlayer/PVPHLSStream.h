//
//  PVPHLSStream.h
//  PTKHLSPlayer
//
//  Created by Rodrigo Sieiro on 13/1/17.
//  Copyright © 2017 Airtime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVPHLSStream : NSObject

@property (readonly) NSUInteger bandwidth;
@property (readonly) NSString *videoCodec;
@property (readonly) NSString *audioCodec;
@property (readonly) NSURL *url;

- (instancetype)initWithMetadata:(NSString *)metadata url:(NSURL *)url;

@end
