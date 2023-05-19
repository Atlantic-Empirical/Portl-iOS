//
//  PTKRoomColorWheelViewController.h
//  portkey
//
//  Created by Adam Bellard on 8/23/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@protocol PTKRoomColorWheelViewControllerDelegate <NSObject>

@required
- (void)colorWheelDidSelectColor:(UIColor *)color;
- (void)colorWheelDidCancelColorSelection;

@end

@interface PTKRoomColorWheelViewController : PTKBaseViewController

@property (strong, nonatomic) UIColor *roomColor;
@property (weak, nonatomic) id<PTKRoomColorWheelViewControllerDelegate>delegate;

@end
