//
//  PTKInstructionsViewController.h
//  portkey
//
//  Created by Daniel Amitay on 5/4/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@interface PTKInstructionsViewController : PTKBaseViewController

@property (nonatomic, readonly) UIButton *closeButton;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *messageLabel;
@property (nonatomic, readonly) UIButton *actionButton;
@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UIButton *footerButton;

- (void)setImage:(UIImage *)image;

// Methods to override
- (void)actionButtonTapped;
- (void)closeButtonTapped;
- (void)footerButtonTapped;

@end
