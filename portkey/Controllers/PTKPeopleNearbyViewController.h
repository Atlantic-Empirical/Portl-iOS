//
//  PTKPeopleNearbyViewController.h
//  portkey
//
//  Created by Daniel Amitay on 12/10/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseTableViewController.h"
#import "PTKPeopleSubviewDelegate.h"

@interface PTKPeopleNearbyViewController : PTKBaseTableViewController

@property (nonatomic, weak) id<PTKPeopleSubviewDelegate> delegate;

- (void)reloadData;

@end
