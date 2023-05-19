//
//  PTKPeopledNoFriendsTableViewCell.h
//  portkey
//
//  Created by Robert Reeves on 11/22/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PTKPeopledNoFriendsTableViewCellDelegate <NSObject>

- (void)userDidTapFindFriendsButton;
@end



@interface PTKPeopledNoFriendsTableViewCell : UITableViewCell

extern CGFloat const kPTKPeopledNoFriendsTableViewCellHeight;


@property (nonatomic, weak) id<PTKPeopledNoFriendsTableViewCellDelegate> delegate;


- (void)hideLabel;
- (void)showLabel;

@end
