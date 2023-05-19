//
//  PTKClipboardBarView.h
//  portkey
//
//  Created by Robert Reeves on 6/18/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PTKClipboardBarViewDelegate <NSObject>

@optional
- (void)clipboardViewDidTapDismiss;
- (void)userDidTapToPasteItem;

@end


@interface PTKClipboardBarView : UIView


@property (nonatomic, weak) id<PTKClipboardBarViewDelegate>delegate;
@property (nonatomic) NSUInteger pasteboardHash;
@property (nonatomic) PTKImageView* imageThumb;
@property (nonatomic) UILabel* labelDescription;
@property (nonatomic) UIButton* buttonDismiss;

@end
