//
//  PTKMaskedView.m
//  portkey
//
//  Created by Rodrigo Sieiro on 20/8/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKMaskedView.h"

@implementation PTKMaskedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.fillRule = kCAFillRuleEvenOdd;
    self.layer.mask = mask;
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CAShapeLayer *mask = (CAShapeLayer *)self.layer.mask;
    mask.frame = self.bounds;
    
    CGMutablePathRef p1 = CGPathCreateMutable();
    CGPathAddPath(p1, nil, self.maskPath.CGPath);
    CGPathRef boundsPath = CGPathCreateWithRect(self.bounds, nil);
    CGPathAddPath(p1, nil, boundsPath);
    CFRelease(boundsPath);
    mask.path = p1;
    CFRelease(p1);
}

@end
