//
//  PTKMessagePreviewViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 4/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@class PTKMessagePreviewViewController;
@protocol PTKMessagePreviewViewControllerDelegate <NSObject>

- (void)messagePreview:(PTKMessagePreviewViewController *)messagePreview dismissWithSuccess:(BOOL)success;

@end

@interface PTKMessagePreviewViewController : PTKBaseViewController

@property (nonatomic, weak) id<PTKMessagePreviewViewControllerDelegate> delegate;
@property (readonly, strong) UIView *messageView;

@property (nonatomic) UITextView *textView;

- (instancetype)initWithMessage:(PTKMessage *)message;
- (instancetype)initWithMessage:(PTKMessage *)message andType:(NSString *)type andMentions:(NSArray*)mentions;

- (void)updateTextViewWithText:(NSString*)text;
- (CGRect) messageViewFromFrame;

@end
