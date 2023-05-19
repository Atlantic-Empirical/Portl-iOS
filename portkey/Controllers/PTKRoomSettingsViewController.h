//
//  PTKRoomSettingsViewController.h
//  portkey
//
//  Created by Adam Bellard on 8/22/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKPushPopViewController.h"

@interface PTKRoomSettingsDescriptionCell : UITableViewCell
@end

@class PTKRoomSettingsViewController;
@protocol PTKRoomSettingsViewControllerDelegate <NSObject>

@optional

- (void)roomSettingsDidLeaveRoom:(PTKRoomSettingsViewController *)roomSettings;

@end

@interface PTKRoomSettingsViewController : PTKPushPopViewController

@property (nonatomic, weak) id<PTKRoomSettingsViewControllerDelegate> delegate;

- (instancetype)initWithRoomId:(NSString *)roomId;
- (void)changeName;

@end
