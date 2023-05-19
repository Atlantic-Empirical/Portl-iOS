//
//  PTKTriangleView.h
//  portkey
//
//  Created by Robert Reeves on 5/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PTKPointDirection) {
    PTKPointDirectionDown,
    PTKPointDirectionUp
};

@interface PTKTriangleView : UIView

- (instancetype)initWithFrame:(CGRect)frame pointDirection:(PTKPointDirection)direction;

- (void)drawRect:(CGRect)rect;


@end
