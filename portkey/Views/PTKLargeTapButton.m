//
//  PTKLargeTapButton.m
//  portkey
//
//  Created by Rodrigo Sieiro on 31/1/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKLargeTapButton.h"

@implementation PTKLargeTapButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(-_tapMargin, -_tapMargin, -_tapMargin, -_tapMargin));
    return CGRectContainsPoint(hitFrame, point);
}

@end
