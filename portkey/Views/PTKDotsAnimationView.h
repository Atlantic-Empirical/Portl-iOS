//
//  PTKDotsAnimationView.h
//  portkey
//
//  Created by Rodrigo Sieiro on 16/12/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PTKDotsAnimationStyleBounce,
    PTKDotsAnimationStylePulse
} PTKDotsAnimationStyle;

@interface PTKDotsAnimationView : UIView

@property PTKDotsAnimationStyle animationStyle;
@property CGFloat spacing;
@property (nonatomic, readonly) BOOL isAnimating;

- (void)startAnimating;
- (void)stopAnimating;

@end
