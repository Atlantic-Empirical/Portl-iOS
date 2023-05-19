//
//  UIView+PTK.h
//  portkey
//
//  Created by Rodrigo Sieiro on 23/4/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PTK)

- (CGFloat)maxX;
- (CGFloat)maxY;
- (CGFloat)midX;
- (CGFloat)midY;
- (CGFloat)height;
- (CGFloat)width;
- (CGFloat)x;
- (CGFloat)y;
- (CGPoint)midPoint;

- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;

- (void)setShadowColor:(UIColor *)shadowColor offset:(CGSize)offset opacity:(float)opacity radius:(CGFloat)radius;
- (UIView *)snapshotForAnimation;
+ (UIView *)viewWithRoundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius;

- (void)addTopSeparatorWithColor:(UIColor *)color;
- (void)addBottomSeparatorWithColor:(UIColor *)color;

@end
