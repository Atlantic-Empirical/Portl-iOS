//
//  PTKContactCollectionViewCell.h
//  PTKContactPicker
//
//  Created by Matt Bowman on 11/20/13.
//  Copyright (c) 2013 Citrrus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PTKContactPickerStyleLightContent,
    PTKContactPickerStyleDarkContent
} PTKContactPickerStyle;

@interface PTKContactCollectionViewContactCell : UICollectionViewCell

@property (nonatomic, strong) PTKContact *model;
@property (nonatomic) BOOL inFocus;
@property (nonatomic, readwrite) PTKContactPickerStyle style;

- (CGFloat)widthForCellWithContact:(PTKContact *)model;

@end
