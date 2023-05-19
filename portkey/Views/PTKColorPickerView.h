//
//  PTKColorPickerView.h
//  portkey
//
//  Created by Rodrigo Sieiro on 6/5/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKColorPickerView;
@protocol PTKColorPickerViewDelegate <NSObject>

@optional
- (void)colorPickerView:(PTKColorPickerView *)view didSelectColor:(UIColor *)color;

@end

@interface PTKColorPickerView : UIView

typedef NS_ENUM(NSInteger, PTKColorPickerViewType) {
    PTKColorPickerViewTypeHorizontalRow,
    PTKColorPickerViewTypeCircle
};


- (instancetype)initWithFrame:(CGRect)frame withPickerType:(PTKColorPickerViewType)pickerType;


@property (nonatomic, assign) BOOL enableCustomColors;
@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, weak) id <PTKColorPickerViewDelegate>delegate;

@end
