//
//  PTKNotificationSetting.m
//  portkey
//
//  Created by Adam Bellard on 2/21/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKNotificationSetting.h"

@implementation PTKNotificationSetting

MODEL_STRING(key, @"key", nil);
MODEL_STRING(title, @"title", nil);
MODEL_STRING(value, @"value", nil);
MODEL_STRING(example, @"example", nil);
MODEL_ARRAY(options, @"options", NSString);

@end
