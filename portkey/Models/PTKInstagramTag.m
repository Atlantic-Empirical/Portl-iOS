//
//  PTKInstagramTag.m
//  portkey
//
//  Created by Rodrigo Sieiro on 6/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKInstagramTag.h"

@implementation PTKInstagramTag

MODEL_STRING(name, @"name", nil)
MODEL_NSUINTEGER(mediaCount, @"mediaCount", 0)

- (NSString *)oid {
    return self.name;
}

@end
