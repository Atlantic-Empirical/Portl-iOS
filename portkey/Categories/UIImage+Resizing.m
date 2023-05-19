//
//  UIImage+Resizing.m
//  portkey
//
//  Created by Daniel Amitay on 5/28/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "UIImage+Resizing.h"

@implementation UIImage (Resizing)

- (UIImage *)imageScaledDownByFactor:(CGFloat)factor {
    return [self imageScaledDownByFactor:factor opaque:NO];
}

- (UIImage *)imageScaledUpByFactor:(CGFloat)factor {
    return [self imageScaledUpByFactor:factor opaque:NO];
}

- (UIImage *)imageScaledToSize:(CGSize)size {
    return [self imageScaledToSize:size opaque:NO];
}

- (UIImage *)imageThatFillsSize:(CGSize)size {
    return [self imageThatFillsSize:size opaque:NO];
}

- (UIImage *)imageThatFitsSize:(CGSize)size {
    return [self imageThatFitsSize:size opaque:NO];
}

- (UIImage *)imageScaledDownByFactor:(CGFloat)factor opaque:(BOOL)opaque {
    return [self imageScaledToSize:(CGSize) {
        .width = self.size.width / factor,
        .height = self.size.height / factor
    } opaque:opaque];
}

- (UIImage *)imageScaledUpByFactor:(CGFloat)factor opaque:(BOOL)opaque {
    return [self imageScaledToSize:(CGSize) {
        .width = self.size.width * factor,
        .height = self.size.height * factor
    } opaque:opaque];
}

- (UIImage *)imageScaledToSize:(CGSize)size opaque:(BOOL)opaque {
    CGRect rect = (CGRect) {
        .size = size
    };
    UIGraphicsBeginImageContextWithOptions(rect.size, opaque, self.scale);
    [self drawInRect:rect];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage *)imageThatFillsSize:(CGSize)size opaque:(BOOL)opaque {
    // Create sized context, then draw current image appropriately
    CGFloat horizontalRatio = size.width / self.size.width;
    CGFloat verticalRatio = size.height / self.size.height;
    CGFloat ratio = MAX(horizontalRatio, verticalRatio);

    CGFloat newWidth = self.size.width * ratio;
    CGFloat newHeight = self.size.height * ratio;

    CGRect drawRect = (CGRect) {
        .size.width = newWidth,
        .size.height = newHeight
    };

    UIGraphicsBeginImageContextWithOptions(drawRect.size, opaque, 0.0f);
    [self drawInRect:drawRect];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (UIImage *)imageThatFitsSize:(CGSize)size opaque:(BOOL)opaque {
    // Create sized context, then draw current image appropriately
    CGFloat horizontalRatio = size.width / self.size.width;
    CGFloat verticalRatio = size.height / self.size.height;
    CGFloat ratio = MIN(horizontalRatio, verticalRatio);

    CGFloat newWidth = self.size.width * ratio;
    CGFloat newHeight = self.size.height * ratio;

    CGRect drawRect = (CGRect) {
        .size.width = newWidth,
        .size.height = newHeight
    };

    UIGraphicsBeginImageContextWithOptions(drawRect.size, opaque, 0.0f);
    [self drawInRect:drawRect];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
