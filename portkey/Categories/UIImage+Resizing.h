//
//  UIImage+Resizing.h
//  portkey
//
//  Created by Daniel Amitay on 5/28/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resizing)

- (UIImage *)imageScaledDownByFactor:(CGFloat)factor;
- (UIImage *)imageScaledUpByFactor:(CGFloat)factor;
- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageThatFillsSize:(CGSize)size;
- (UIImage *)imageThatFitsSize:(CGSize)size;

- (UIImage *)imageScaledDownByFactor:(CGFloat)factor opaque:(BOOL)opaque;
- (UIImage *)imageScaledUpByFactor:(CGFloat)factor opaque:(BOOL)opaque;
- (UIImage *)imageScaledToSize:(CGSize)size opaque:(BOOL)opaque;
- (UIImage *)imageThatFillsSize:(CGSize)size opaque:(BOOL)opaque;
- (UIImage *)imageThatFitsSize:(CGSize)size opaque:(BOOL)opaque;

@end
