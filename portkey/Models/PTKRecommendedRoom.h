//
//  PTKRecommendedRoom.h
//  portkey
//
//  Created by Rodrigo Sieiro on 14/1/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@interface PTKRecommendedRoom : PTKModel

- (PTKRoom *)room;
- (NSArray<PTKUser *> *)users;
- (double)score;

@end
