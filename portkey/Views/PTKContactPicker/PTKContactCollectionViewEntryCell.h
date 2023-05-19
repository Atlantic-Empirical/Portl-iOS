//
//  PTKContactEntryCollectionViewCell.h
//  PTKContactPicker
//
//  Created by Matt Bowman on 11/21/13.
//  Copyright (c) 2013 Citrrus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKContactCollectionViewContactCell.h"

@protocol UITextFieldDelegateImproved <UITextFieldDelegate>

- (void)textFieldDidChange:(UITextField*)textField;

@end

@interface PTKContactCollectionViewEntryCell : UICollectionViewCell

@property (nonatomic, weak) id<UITextFieldDelegateImproved> delegate;
@property (nonatomic, copy) NSString *text;
@property (nonatomic) NSString *placeholder;
@property (nonatomic) BOOL enabled;
@property (nonatomic) PTKContactPickerStyle style;

- (void)setFocus;
- (void)removeFocus;
- (void)reset;
- (void)updatePlaceholder;
- (CGFloat)widthForText:(NSString*)text;

@end
