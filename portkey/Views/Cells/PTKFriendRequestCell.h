//
//  PTKFriendRequestCell.h
//  portkey
//
//  Created by Rodrigo Sieiro on 5/7/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKGenericCellDelegate.h"

@interface PTKFriendRequestCell : UITableViewCell

@property (nonatomic, strong) PTKUser *user;
@property (nonatomic, weak) id<PTKGenericTableViewCellDelegate> delegate;

@end
