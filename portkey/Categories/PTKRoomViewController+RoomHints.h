//
//  PTKRoomViewController+RoomHints.h
//  portkey
//
//  Created by Robert Reeves on 5/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKRoomViewController.h"

@interface PTKRoomViewController (RoomHints)

- (void)launchHintView:(PTKHintType)hintType relatedUserId:(NSString *)userId;

- (void)dismissHintViewWithCompletion:(void (^)())completion;

- (void)transitionHintViewToNextStep;

- (BOOL)shouldIgnoreHintLaunchRequest:(PTKHintType)hintType;

@end
