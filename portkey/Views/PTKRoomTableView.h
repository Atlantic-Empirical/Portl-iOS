//
//  PTKRoomTableView.h
//  portkey
//
//  Created by Rodrigo Sieiro on 15/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKRoomHeaderView;
@interface PTKRoomTableView : UITableView

@property (nonatomic, strong) PTKRoomHeaderView *headerView;
@property (nonatomic) CGFloat minHeaderHeight;
@property (nonatomic) CGFloat defaultHeaderHeight;
@property (nonatomic) BOOL lockHeader;
@property (nonatomic) BOOL alternateHeader;

- (void)reloadDataAndLayout;
- (void)scrollToContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
- (void)scrollToBottomAnimated:(BOOL)animated;
- (void)openHeader:(BOOL)animated;
- (void)closeHeader:(BOOL)animated;
- (BOOL)canScrollContent;
- (BOOL)isAtBottom;

@end

@protocol PTKRoomTableViewDelegate <UITableViewDelegate>
@optional
- (void)tableViewDidLayout:(PTKRoomTableView *)tableView;

@end
