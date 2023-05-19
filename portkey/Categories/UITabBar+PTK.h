//
//  UITabBar+PTK.h
//  portkey
//
//  Created by Daniel Amitay on 11/20/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (PTK)

- (void)enableCustomTabBar;

- (void)setColor:(UIColor *)color forBadgeAtIndex:(NSInteger)index;
- (UIColor *)colorForBadgeAtIndex:(NSInteger)index;
- (void)setValue:(NSString *)value forBadgeAtIndex:(NSInteger)index;
- (NSString *)valueForBadgeAtIndex:(NSInteger)index;

@end
