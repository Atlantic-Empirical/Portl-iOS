//
//  PTKOneToOneRowCell.h
//  portkey
//
//  Created by Robert Reeves on 6/8/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTKOneToOneRowCellDelegate <NSObject>

@optional
- (void)userDidTapOneToOneWithRoomId:(NSString *)roomId;
- (void)userDidLongPressOneToOneWithRoomId:(NSString *)roomId;
- (void)didTapAddFriendButton;

@end


@interface PTKOneToOneRowCell : UITableViewCell

@property (nonatomic, weak) id<PTKOneToOneRowCellDelegate> delegate;

+ (CGFloat)desiredHeight;
- (void)updateWithUsersInOneToOneRooms:(NSArray*)rooms;

@end
