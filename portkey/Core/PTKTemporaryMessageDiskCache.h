//
//  PTKTemporaryMessageDiskCache.h
//  portkey
//
//  Created by Rodrigo Sieiro on 2/3/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKTemporaryMessageDiskCache : NSObject

- (void)storeMessage:(NSDictionary *)json;
- (NSArray *)fetchAndClearMessages;

@end
