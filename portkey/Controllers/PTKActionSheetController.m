//
//  PTKActionSheetController.m
//  portkey
//
//  Created by Daniel Amitay on 4/21/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKActionSheetController.h"

@interface PTKActionSheetController ()

@end

@implementation PTKActionSheetController

#pragma mark - Initializers

+ (instancetype)actionSheetController {
    return [self actionSheetControllerWithTitle:nil message:nil];
}

+ (instancetype)actionSheetControllerWithTitle:(NSString *)title message:(NSString *)message {
    return [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
}


#pragma mark - Layout methods

- (BOOL)shouldAutorotate {
	return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Button creation

- (NSUInteger)addButtonWithTitle:(NSString *)title style:(UIAlertActionStyle)style block:(PTKActionSheetBlock)block {
    void (^actionHandler)(UIAlertAction *action) = (block ? ^(UIAlertAction *action) {block();} : nil);
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:style handler:actionHandler];
    [self addAction:action];
    return self.actions.count - 1;
}

- (NSUInteger)addButtonWithTitle:(NSString *)title block:(PTKActionSheetBlock)block {
    return [self addButtonWithTitle:title style:UIAlertActionStyleDefault block:block];
}

- (NSUInteger)addDestructiveButtonWithTitle:(NSString *)title block:(PTKActionSheetBlock)block {
    return [self addButtonWithTitle:title style:UIAlertActionStyleDestructive block:block];
}

- (NSUInteger)addCancelButtonWithTitle:(NSString *)title block:(PTKActionSheetBlock)block {
    return [self addButtonWithTitle:title style:UIAlertActionStyleCancel block:block];
}

- (NSUInteger)addCancelButtonWithTitle:(NSString *)title {
    return [self addCancelButtonWithTitle:title block:nil];
}

@end
