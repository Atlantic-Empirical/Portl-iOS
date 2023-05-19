//
//  PTKRoomTrayInviteViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 23/8/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKPushPopViewController.h"

@interface PTKRoomTrayInviteViewController : PTKPushPopViewController

- (instancetype)initWithRoomId:(NSString *)roomId appLocation:(NSString *)appLocation;
- (void)setRoomColor:(UIColor *)roomColor;

@end
