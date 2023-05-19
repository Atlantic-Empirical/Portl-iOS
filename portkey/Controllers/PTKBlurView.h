//
//  PTKBlurView.h
//  portkey
//
//  Created by Robert Reeves on 4/20/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "FXBlurView.h"

typedef NS_ENUM(NSInteger, PTKBlurViewType) {
    PTKBlurViewTypeUnknown,
    PTKBlurViewTypeDark,
    PTKBlurViewTypeLight
};

@interface PTKBlurView : FXBlurView



/**
 init PTKBlurView
 @param CGRect frame for view
 @param UIView view to be blurred
 @param CGFloat blurRadius for blurred view
 @param PTKBlurViewType styled dark or light
 */
- (id)initWithFrame:(CGRect)frame withUnderlyingView:(UIView*)view withBlurRadius:(CGFloat)blurRadius withBlurType:(PTKBlurViewType)blurType;


@end
