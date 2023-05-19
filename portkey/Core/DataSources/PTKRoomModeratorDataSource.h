//
//  PTKRoomModeratorDataSource.h
//  portkey
//
//  Created by Adam Bellard on 10/7/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKPaginatedDataSource.h"

@interface PTKRoomModeratorDataSource : PTKPaginatedDataSource

@property (nonatomic, copy) NSString *roomId;

- (instancetype)initWithRoomId:(NSString *)roomId limit:(NSUInteger)limit;

- (BOOL)userIsModerator:(NSString *)userId;

@end
