//
//  PTKStickyHeaderTableView.h
//  portkey
//
//  Created by Daniel Amitay on 5/1/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKStickyHeaderTableView : UITableView

@property (nonatomic, strong) UIView *stickyHeaderView;
@property (nonatomic, readonly) UIView *stage;
@property (nonatomic) CGFloat maxHeaderHeight;
@property (nonatomic) CGFloat minHeaderHeight;
@property (nonatomic) CGFloat defaultHeaderHeight;

@end

@protocol PTKStickyHeaderTableViewDelegate
@optional
- (void)tableViewDidLayoutHeader:(PTKStickyHeaderTableView *)tableView;

@end
