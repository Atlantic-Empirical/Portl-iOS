//
//  PTKColorWheelView.h
//  portkey
//
//  Created by Adam Bellard on 8/23/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTKColorWheelViewDelegate <NSObject>

@required
- (void)colorWheelSelectedColor:(UIColor *)color;

@end

@interface PTKColorWheelView : UIView

@property (nonatomic, strong) UIColor *currentColor;
@property (weak, nonatomic) id<PTKColorWheelViewDelegate>delegate;

@end
