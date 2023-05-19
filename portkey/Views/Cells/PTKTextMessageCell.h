//
//  PTKTextMessageCell.h
//  portkey
//
//  Created by Rodrigo Sieiro on 17/11/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseMessageCell.h"

@interface PTKTextMessageCell : PTKBaseMessageCell

@property (readonly) UIImageView *messageSentCircle;

- (void)createBodyViewWithLabel:(BOOL)withLabel;
- (void)updateBodyViewBackground;
- (UIView *)viewAtLocation:(CGPoint)location;

@end
