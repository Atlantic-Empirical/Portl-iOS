//
//  PTKRoomTrayViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 18/8/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@protocol PTKRoomSettingsViewControllerDelegate;
@interface PTKRoomTrayViewController : PTKBaseViewController

@property (nonatomic, weak) id<PTKRoomSettingsViewControllerDelegate> settingsDelegate;

- (instancetype)initWithRoomId:(NSString *)roomId;
- (void)setContainerX:(CGFloat)newX;
- (void)manualTransitionEnded;
- (void)manualTransitionEndedWithVelocity:(CGPoint)velocity;

@end
