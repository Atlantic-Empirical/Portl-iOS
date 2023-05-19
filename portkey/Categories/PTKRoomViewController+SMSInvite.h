//
//  PTKRoomViewController+SMSInvite.h
//  portkey
//
//  Created by Robert Reeves on 3/15/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKRoomViewController.h"
#import "PTKInviteHelper.h"

@interface PTKRoomViewController (SMSInvite) <PTKInviteHelperDelegate>

- (void)inviteContact:(PTKContact *)contact;

@end
