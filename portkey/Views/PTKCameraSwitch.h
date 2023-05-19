//
//  PTKCameraSwitch.h
//  portkey
//
//  Created by Rodrigo Sieiro on 8/8/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKCameraSwitch : UIControl

@property (nonatomic) UIEdgeInsets padding;
@property (nonatomic, assign, getter=isOn) BOOL on;

@property (nonatomic) BOOL canControlStage;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
