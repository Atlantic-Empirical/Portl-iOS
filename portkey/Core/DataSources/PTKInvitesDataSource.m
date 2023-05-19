//
//  PTKInvitesDataSource.m
//  portkey
//
//  Created by Adam Bellard on 2/5/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKInvitesDataSource.h"
#import "PTKInvite.h"

@implementation PTKInvitesDataSource

#pragma mark - Subclass methods

- (PTKAPIRequest *)fetchDataWithSkip:(NSUInteger)skip limit:(NSUInteger)limit callback:(PTKAPICallback *)callback {
    return [PTKAPI fetchUserInvitesWithCallback:callback];
}

- (PTKModel *)objectFromJSON:(NSDictionary *)JSON {
    return [[PTKInvite alloc] initWithJSON:JSON];
}

@end
