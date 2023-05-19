//
//  PTKPendingFriendCell.h
//  portkey
//
//  Created by Rodrigo Sieiro on 18/2/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKPendingFriendCell;
@protocol PTKPendingFriendCellDelegate <NSObject>

@optional
- (void)pendingFriendCellDidAccept:(PTKPendingFriendCell *)cell;
- (void)pendingFriendCellDidIgnore:(PTKPendingFriendCell *)cell;
- (void)pendingFriendCellDidTap:(PTKPendingFriendCell *)cell;

@end

@interface PTKPendingFriendCell : UITableViewCell

@property (nonatomic, strong) PTKUser *user;
@property (nonatomic, weak) id<PTKPendingFriendCellDelegate> delegate;

+ (CGFloat)desiredHeight;

@end
