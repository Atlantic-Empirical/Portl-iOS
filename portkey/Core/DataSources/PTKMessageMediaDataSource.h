//
//  PTKMessageMediaDataSource.h
//  portkey
//
//  Created by Rodrigo Sieiro on 23/8/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKPaginatedDataSource.h"

@interface PTKMessageMediaDataSource : PTKPaginatedDataSource

@property (nonatomic, copy) NSString *roomId;

- (instancetype)initWithRoomId:(NSString *)roomId limit:(NSUInteger)limit;

@end
