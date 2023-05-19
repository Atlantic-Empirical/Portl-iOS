//
//  PTKAccountSettingsViewController.h
//  portkey
//
//  Created by Daniel Amitay on 4/29/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseTableViewController.h"

@class PTKAccountSettingsViewController;
@protocol PTKAccountSettingsViewControllerDelegate <NSObject>

- (void)accountSettingsDidClose:(PTKAccountSettingsViewController *)accountSettings;

@end

@interface PTKAccountSettingsViewController : PTKBaseTableViewController

@property (nonatomic, weak) id<PTKAccountSettingsViewControllerDelegate> delegate;

@end
