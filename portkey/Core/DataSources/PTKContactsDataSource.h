//
//  PTKContactsDataSource.h
//  portkey
//
//  Created by Daniel Amitay on 5/8/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKContact.h"
#import "PTKPaginatedDataSource.h"

@interface PTKContactsDataSource : PTKPaginatedDataSource

@property (nonatomic, readonly) NSArray *friendContacts;
@property (nonatomic, readonly) NSArray *nonFriendContacts;
@property (nonatomic, readonly) NSArray *nonUserContacts;
@property (nonatomic, readonly) NSArray *allLocalContacts;

@end
