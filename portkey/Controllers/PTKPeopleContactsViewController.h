//
//  PTKPeopleContactsViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 6/2/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKBaseTableViewController.h"
#import "PTKPeopleSubviewDelegate.h"

@interface PTKPeopleContactsViewController : PTKBaseTableViewController

@property (nonatomic, assign) BOOL isUsernameSearch;
@property (nonatomic, weak) id<PTKPeopleSubviewDelegate> delegate;

- (void)reloadData;

@end
