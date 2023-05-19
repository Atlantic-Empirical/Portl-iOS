//
//  PTKBaseTableViewController.h
//  portkey
//
//  Created by Daniel Amitay on 5/11/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@interface PTKBaseTableViewController : PTKBaseViewController <UITableViewDelegate, UITableViewDataSource>

- (instancetype)initWithStyle:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear NS_AVAILABLE_IOS(3_2); // defaults to YES. If YES, any selection is cleared in viewWillAppear:

@end
