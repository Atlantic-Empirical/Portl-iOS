//
//  PVPHLSSegment.h
//  PTKHLSPlayer
//
//  Created by Rodrigo Sieiro on 11/1/17.
//  Copyright © 2017 Airtime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVPHLSSegment : NSObject

@property (readonly) NSUInteger sequence;
@property (readonly) NSString *name;
@property (readonly) double duration;
@property (copy) NSURL *url;
@property (copy) NSURL *fileURL;

@property BOOL downloaded;
@property BOOL redownloaded;
@property BOOL parsed;

- (instancetype)initWithSequence:(NSUInteger)sequence url:(NSURL *)url duration:(double)duration;

@end
