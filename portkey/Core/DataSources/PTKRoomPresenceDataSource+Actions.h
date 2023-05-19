//
//  PTKRoomPresenceDataSource+Actions.h
//  portkey
//
//  Created by Seth Samuel on 9/29/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKRoomPresenceDataSource.h"

@interface PTKRoomPresenceDataSource (Actions)

- (void) updatePresences:(NSArray<PTKRoomPresence *> *) presences;
- (void) updatePresence:(PTKRoomPresence *) presence andUpdateProperties:(BOOL)updateProperties;
- (void) updateMembers;
- (void) userDidSendMessage:(NSString *) userId;
- (void) clearActivePresences;
@end
