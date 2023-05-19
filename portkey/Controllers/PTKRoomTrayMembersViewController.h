//
//  PTKRoomTrayMembersViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 18/8/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseTableViewController.h"

@class PTKRoomTrayMembersViewController;
@protocol PTKRoomTrayMembersViewControllerDelegate <NSObject>

@optional
- (void)requestFullScreenForRoomTrayMembers:(PTKRoomTrayMembersViewController *)roomTrayMembers;
- (void)resignFullScreenForRoomTrayMembers:(PTKRoomTrayMembersViewController *)roomTrayMembers;

@end

@interface PTKRoomTrayMembersViewController : PTKBaseTableViewController

@property (nonatomic, weak) id<PTKRoomTrayMembersViewControllerDelegate> delegate;
@property (nonatomic, assign) UIEdgeInsets originalInsets;

- (instancetype)initWithRoomId:(NSString *)roomId;
- (void)setRoomColor:(UIColor *)roomColor;
- (void)scrollToTop;

@end
