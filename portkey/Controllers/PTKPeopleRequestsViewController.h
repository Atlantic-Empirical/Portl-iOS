//
//  PTKPeopleRequestsViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 18/1/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKBaseTableViewController.h"
#import "PTKPeopleSubviewDelegate.h"

@interface PTKPeopleRequestsViewController : PTKBaseTableViewController

@property (nonatomic, weak) id<PTKPeopleSubviewDelegate> delegate;
@property (nonatomic, strong) NSArray *friendRequests;
@property (nonatomic, strong) NSArray *suggestedFriends;

- (void)scrollToTopAnimated:(BOOL)animated;

@end
