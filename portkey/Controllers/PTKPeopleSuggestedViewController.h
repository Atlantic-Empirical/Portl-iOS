//
//  PTKPeopleSuggestedViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 8/2/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKBaseTableViewController.h"
#import "PTKPeopleSubviewDelegate.h"

@interface PTKPeopleSuggestedViewController : PTKBaseTableViewController

@property (nonatomic, weak) id<PTKPeopleSubviewDelegate> delegate;

- (void)reloadData;

@end
