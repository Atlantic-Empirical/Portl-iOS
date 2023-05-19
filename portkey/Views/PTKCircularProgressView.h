//
//  PTKCircularProgressView.h
//  portkey
//
//  Created by Rodrigo Sieiro on 23/6/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKCircularProgressView : UIView

@property (nonatomic, assign) BOOL failed;
@property (nonatomic, assign) float progress;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
