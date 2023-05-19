//
//  PTKNotificationSetting.h
//  portkey
//
//  Created by Adam Bellard on 2/21/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@interface PTKNotificationSetting : PTKModel

- (NSString *)key;
- (NSString *)title;
- (NSString *)value;
- (NSString *)example;
- (NSArray *)options;

@end
