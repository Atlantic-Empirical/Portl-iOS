//
//  PTKPeopleFriendsViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 18/1/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKBaseTableViewController.h"
#import "PTKPeopleSubviewDelegate.h"

@interface PTKPeopleFriendsViewController : PTKBaseTableViewController

@property (nonatomic, weak) id<PTKPeopleSubviewDelegate> delegate;
@property (nonatomic, strong) NSArray *oneToOneRooms;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *suggestedFriends;

- (void)scrollToTopAnimated:(BOOL)animated;

@end
