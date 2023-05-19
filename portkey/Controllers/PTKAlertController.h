//
//  PTKAlertController.h
//  portkey
//
//  Created by Daniel Amitay on 4/21/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PTKAlertBlock)(void);

@interface PTKAlertController : UIAlertController

#pragma mark - Initializers

+ (instancetype)alertController;
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;

#pragma mark - Button creation

- (NSUInteger)addButtonWithTitle:(NSString *)title block:(PTKAlertBlock)block;
- (NSUInteger)addDestructiveButtonWithTitle:(NSString *)title block:(PTKAlertBlock)block;
- (NSUInteger)addCancelButtonWithTitle:(NSString *)title block:(PTKAlertBlock)block;
- (NSUInteger)addCancelButtonWithTitle:(NSString *)title;

@end
