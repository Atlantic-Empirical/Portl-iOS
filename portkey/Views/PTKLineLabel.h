//
//  PTKLineLabel.h
//  portkey
//
//  Created by Rodrigo Sieiro on 6/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 
Note: the reason this is a UIView subclass and not a UILabel subclass
is because subviews inside a UILabel don't work right if the
text includes emoji characters. ¯\_(ツ)_/¯
*/

@interface PTKLineLabel : UIView

@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) NSString *text;
@property (nonatomic) NSAttributedString *attributedText;
@property (nonatomic, assign) CGFloat lineMargin;
@property (nonatomic, assign) CGFloat linePadding;
@property (nonatomic, assign) BOOL gradient;

@end
