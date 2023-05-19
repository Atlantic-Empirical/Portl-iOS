//
//  UIView+PTK.m
//  portkey
//
//  Created by Rodrigo Sieiro on 23/4/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "UIView+PTK.h"

@implementation UIView (PTK)

- (CGFloat)maxX {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)maxY {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)midX {
    return self.frame.origin.x + ceilcg(self.frame.size.width / 2.0f);
}

- (CGFloat)midY {
    return self.frame.origin.y + ceilcg(self.frame.size.height / 2.0f);
}

- (CGFloat)height {
    return self.bounds.size.height;
}

- (CGFloat)width {
    return self.bounds.size.width;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGPoint)midPoint {
    return CGPointMake(ceilcg(self.width / 2.0f), ceilcg(self.height / 2.0f));
}

- (void)setOrigin:(CGPoint)origin {
    self.frame = (CGRect) { .origin = origin, .size = self.frame.size };
}

- (void)setSize:(CGSize)size {
    self.frame = (CGRect) { .origin = self.frame.origin, .size = size };
}

- (void)setShadowColor:(UIColor *)shadowColor offset:(CGSize)offset opacity:(float)opacity radius:(CGFloat)radius {
    self.layer.shadowColor = [shadowColor CGColor];
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}

- (UIView *)snapshotForAnimation {
    UIView *animationView;
    
    if ([self isKindOfClass:[UIImageView class]]) {
        animationView = [[UIImageView alloc] initWithImage:((UIImageView *)self).image];
        animationView.bounds = self.bounds;
        animationView.contentMode = self.contentMode;
        animationView.transform = self.transform;
        animationView.clipsToBounds = self.clipsToBounds;
    } else {
        animationView = [self snapshotViewAfterScreenUpdates:YES];
    }
    
    return animationView;
}

- (void)addTopSeparatorWithColor:(UIColor *)color {
    UIView *separator = [[UIView alloc] init];
    separator.frame = CGRectMake(0.0f, 0.0f, self.width, [PTKGraphics onePixelAtAnyScale]);
    separator.backgroundColor = color;
    separator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:separator];
}

- (void)addBottomSeparatorWithColor:(UIColor *)color {
    UIView *separator = [[UIView alloc] init];
    separator.frame = CGRectMake(0.0f, self.height - [PTKGraphics onePixelAtAnyScale], self.width, [PTKGraphics onePixelAtAnyScale]);
    separator.backgroundColor = color;
    separator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:separator];
}

+ (UIView *)viewWithRoundCornersOnView:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {
    if (tl || tr || bl || br) {
        UIRectCorner corner = 0;
        if (tl) corner = corner | UIRectCornerTopLeft;
        if (tr) corner = corner | UIRectCornerTopRight;
        if (bl) corner = corner | UIRectCornerBottomLeft;
        if (br) corner = corner | UIRectCornerBottomRight;
        
        UIView *roundedView = view;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;
        return roundedView;
    }
    return view;
}

@end
