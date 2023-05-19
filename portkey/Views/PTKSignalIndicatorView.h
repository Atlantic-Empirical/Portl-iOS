//
//  PTKSignalIndicatorView.h
//  portkey
//
//  Created by Daniel Amitay on 5/20/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKSignalIndicatorView : UIView

@property (nonatomic, assign, readonly) BOOL isAnimating;

@property (nonatomic) BOOL backViewHidden;
@property (nonatomic) BOOL topViewHidden;

@property (nonatomic) CGFloat smallRadius;  // 11.5f default
@property (nonatomic) CGFloat mediumRadius; // 20.5f default
@property (nonatomic) CGFloat largeRadius;  // 25.0f default

- (void)start;
- (void)stop;

@end
