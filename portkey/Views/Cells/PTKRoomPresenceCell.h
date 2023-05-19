//
//  PTKRoomPresenceCell.h
//  portkey
//
//  Created by Rodrigo Sieiro on 20/10/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKRoomPresence;
@interface PTKRoomPresenceCell : UICollectionViewCell

@property (readonly, strong) PTKRoomPresence *presence;
@property (nonatomic, strong) UIButton *addFriendButton;
@property (assign) BOOL shouldOverrideColorsWithBlack;

- (BOOL)updateWithPresence:(PTKRoomPresence *)presence showNames:(BOOL)showNames animated:(BOOL)animated;
- (void)setCameraView:(UIView *)cameraView animated:(BOOL)animated;
- (void)setRippleIsOver:(BOOL)rippleIsOver;
- (void)animationTimerTick;
- (void)removeAnimations;
+ (CGFloat)sizeForAvatarWithPresence:(PTKRoomPresence *)presence;

@end
