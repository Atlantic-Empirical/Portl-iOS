//
//  PTKProfileListViewController.h
//  portkey
//
//  Created by Robert Reeves on 1/19/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@interface PTKProfileListViewController : PTKBaseViewController

- (instancetype)initWithFriends:(NSArray*)friendsList withUser:(PTKUser*)user;

@end
