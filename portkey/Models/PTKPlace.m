//
//  PTKPlace.m
//  portkey
//
//  Created by Robert Reeves on 10/29/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import "PTKPlace.h"

@implementation PTKPlace


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)c
{
    [c encodeObject:self.name forKey:@"name"];
    [c encodeDouble:self.lat forKey:@"lat"];
    [c encodeDouble:self.lng forKey:@"lng"];
}

- (id)initWithCoder:(NSCoder *)d
{
    self = [super init];
    if (!self) return nil;
    
    self.name = [d decodeObjectForKey:@"name"];
    self.lat = [d decodeDoubleForKey:@"lat"];
    self.lng = [d decodeDoubleForKey:@"lng"];
    
    return self;
}

@end
