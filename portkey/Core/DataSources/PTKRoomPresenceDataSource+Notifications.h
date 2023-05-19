//
//  PTKRoomPresenceDataSource+Notifications.h
//  portkey
//
//  Created by Seth Samuel on 9/29/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKRoomPresenceDataSource.h"

@interface PTKRoomPresenceDataSource (Notifications)

- (void)onPresenceSynced:(NSNotification *)notification;
- (void)onPresenceUpdated:(NSNotification *)notification;
- (void)onRoomMembersInvited:(NSNotification *)notification;
- (void)onRoomMembersAdded:(NSNotification *)notification;
- (void)onRoomMembersRemoved:(NSNotification *)notification;
- (void)onRoomNewMessage:(NSNotification *)notification;
- (void)onChannelConnected:(NSNotification *)n;

- (void)onChannelDisconnected:(NSNotification *)n;


@end
