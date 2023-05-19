//
//  PTKParticlesView.h
//  portkey
//
//  Created by Seth Samuel on 12/14/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKParticlesView : UIView

@property CGFloat particleSize;
@property BOOL shouldWrapAround;

- (void) clearParticles;
/**
 @param point A point within the current view frame
 @parm velocity Max velocity of particles, between 0 and 1
 */
- (void) add:(NSInteger)count particlesAtFramePoint:(CGPoint)point withMaxVelocity:(CGSize)velocity;
/**
 @param point A point within the unit box
 @parm velocity Max velocity of particles, between 0 and 1
 */
- (void) add:(NSInteger)count particlesAtScaledPoint:(CGPoint)point withMaxVelocity:(CGSize)velocity;

@end
