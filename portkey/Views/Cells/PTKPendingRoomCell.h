//
//  PTKPendingRoomCell.h
//  portkey
//
//  Created by Rodrigo Sieiro on 20/1/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTKPendingRoomCellDelegate <NSObject>

- (void)userDidTapAvatar:(PTKUser*)user;

@end

@interface PTKPendingRoomCell : UITableViewCell

@property (nonatomic, strong) PTKRoom *room;
@property (nonatomic, weak) id<PTKPendingRoomCellDelegate> delegate;

@end
