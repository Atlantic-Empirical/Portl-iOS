//
//  PTKRoomsSearchDataSource.h
//  portkey
//
//  Created by Daniel Amitay on 8/31/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKRoomsDataSource.h"

@interface PTKRoomsSearchDataSource : PTKPaginatedDataSource

@property (nonatomic, copy) NSString *searchTerm;

@end
