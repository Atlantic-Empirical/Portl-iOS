//
//  PTKPlace.h
//  portkey
//
//  Created by Robert Reeves on 10/29/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKPlace : NSObject <NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;

@end
