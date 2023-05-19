//
//  PTKUnlinkedContactsDataSource.h
//  portkey
//
//  Created by Rodrigo Sieiro on 29/7/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKPaginatedDataSource.h"

@class PTKUnlinkedContact;
@interface PTKUnlinkedContactsDataSource : PTKPaginatedDataSource

- (PTKUnlinkedContact *)contactWithHash:(NSString *)hash;

@end
