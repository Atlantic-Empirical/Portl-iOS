//
//  PTKActivityCell.h
//  portkey
//
//  Created by Adam Bellard on 10/29/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKActivity.h"
@class PTKActivityCell;

@protocol PTKActivityCellDelegate <NSObject>

- (void)userDidTapAvatar:(PTKUser*)user;
- (void)userDidTapInfoImageWith:(PTKActivityCell*)activityCell;

@end

@interface PTKActivityCell : UITableViewCell

@property (readwrite, strong) PTKActivity *activity;
@property (nonatomic) NSIndexPath* indexPath;
@property (nonatomic, weak) id<PTKActivityCellDelegate> delegate;

@property (nonatomic) PTKImageView *infoImageView;

- (void)updateAccessoryViewForCheckmark;

@end
