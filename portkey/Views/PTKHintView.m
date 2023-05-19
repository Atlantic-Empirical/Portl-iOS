//
//  PTKHintView.m
//  portkey
//
//  Created by Seth Samuel on 1/19/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKHintView.h"

@implementation PTKHintView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self.cutoutPath containsPoint:point]) {
        return nil;
    }
    return [super hitTest:point withEvent:event];
}
@end
