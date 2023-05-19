//
//  PTKHintMessagePropertyCell.h
//  portkey
//
//  Created by Adam Bellard on 4/6/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKHintMessagePropertyCell : UIView {
    
    UILabel *_propertyLabel;
    UIButton *_propertyButton;
}

@property (nonatomic, strong) UIImage *propertyImage;
@property (nonatomic, strong) UIImageView *propertyImageView;
@property (nonatomic, strong) NSAttributedString *propertyText;

- (void)layoutSubviews;
- (void)addTarget:(id) target andSelector:(SEL)selector;

@end
