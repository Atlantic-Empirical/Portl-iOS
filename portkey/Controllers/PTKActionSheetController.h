//
//  PTKActionSheetController.h
//  portkey
//
//  Created by Daniel Amitay on 4/21/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PTKActionSheetBlock)(void);

@interface PTKActionSheetController : UIAlertController

#pragma mark - Initializers

+ (instancetype)actionSheetController;
+ (instancetype)actionSheetControllerWithTitle:(NSString *)title message:(NSString *)message;

#pragma mark - Button creation

- (NSUInteger)addButtonWithTitle:(NSString *)title block:(PTKActionSheetBlock)block;
- (NSUInteger)addDestructiveButtonWithTitle:(NSString *)title block:(PTKActionSheetBlock)block;
- (NSUInteger)addCancelButtonWithTitle:(NSString *)title block:(PTKActionSheetBlock)block;
- (NSUInteger)addCancelButtonWithTitle:(NSString *)title;

@end
