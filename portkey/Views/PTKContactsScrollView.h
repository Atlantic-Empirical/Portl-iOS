//
//  PTKContactsScrollView.h
//  portkey
//
//  Created by Daniel Amitay on 11/17/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKContactsScrollView;
@protocol PTKContactsScrollViewDelegate <NSObject>

@optional
- (void)contactsScrollView:(PTKContactsScrollView *)scrollView didSelectContact:(PTKContact *)contact atIndex:(NSInteger)index;

@end

@interface PTKContactsScrollView : UIView

@property (nonatomic, copy) NSArray *contacts;
@property (nonatomic, weak) id <PTKContactsScrollViewDelegate> delegate;

- (void)addContact:(PTKContact *)contact animated:(BOOL)animated;
- (void)removeContact:(PTKContact *)contact animated:(BOOL)animated;

- (void)scrollToEnd:(BOOL)animated;

@end
