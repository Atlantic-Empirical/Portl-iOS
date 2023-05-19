//
//  PTKFont.h
//  portkey
//
//  Created by Daniel Amitay on 4/21/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKFont : NSObject

+ (UIFont *)regularFontOfSize:(CGFloat)size;
+ (UIFont *)semiBoldFontOfSize:(CGFloat)size;
+ (UIFont *)italicFontWithSize:(CGFloat)size;
+ (UIFont *)mediumFontOfSize:(CGFloat)size;
+ (UIFont *)mediumItalicFontOfSize:(CGFloat)size;
+ (UIFont *)boldFontOfSize:(CGFloat)size;
+ (UIFont *)extraBoldFontOfSize:(CGFloat)size;

@end
