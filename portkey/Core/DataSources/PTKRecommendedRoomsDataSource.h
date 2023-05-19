//
//  PTKRecommendedRoomsDataSource.h
//  portkey
//
//  Created by Daniel Amitay on 11/24/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKRecommendedRoomsDataSource : PTKPaginatedDataSource

- (void)acceptRecommendedRoom:(NSString *)roomId callback:(PTKAPICallback*)callback;
- (void)dismissRecommendedRoom:(NSString *)roomId;
- (NSArray<PTKRoom*> *) rooms;

@end
