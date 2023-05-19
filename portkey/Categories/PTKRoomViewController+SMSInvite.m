//
//  PTKRoomViewController+SMSInvite.m
//  portkey
//
//  Created by Robert Reeves on 3/15/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKRoomViewController+SMSInvite.h"
#import "PTKAPI.h"

@implementation PTKRoomViewController (SMSInvite)

- (void)inviteContact:(PTKContact *)contact  {
    if (!contact) return;

    PTKAPICallback *callback = [PTKAPI callbackWithTarget:self selector:@selector(onDidFetchLink:) userInfo:@{@"contact": contact}];
    [PTKAPI linkForRoom:_roomId callback:callback];
}

#pragma mark - API Callbacks

- (void)onDidFetchLink: (PTKAPIResponse *)response {
    PTKContact *contact = [response.userInfo objectForKey:@"contact"];
    _roomLink = response.JSON[@"link"];

    if (!_inviteHelper) {
        _inviteHelper = [[PTKInviteHelper alloc] initWithDelegate:self];
    }

    [PTKEventTracker trackGraphInviteTappedWithType:(_inviteHelper.isServerSideSMS) ? kGRServerSMS : kGRSMS inviteType:kInviteTypeRoom roomId:self.roomId andAppLocation:kALPresence isContact:YES index:0];
    [_inviteHelper showInviteForContact:contact inViewController:self];
}

#pragma mark - PTKInviteHelperDelegate

- (NSString *)inviteHelperTextForInvite:(PTKInviteHelper *)inviteHelper {
    PTKRoom *room = [[PTKWeakSharingManager roomsDataSource] objectWithId:_roomId];
    return [PTKCopyHelper inviteTextForRoom:room link:_roomLink];
}

- (NSString *)inviteHelperRequiredTextForInvite:(PTKInviteHelper *)inviteHelper {
    return _roomLink;
}

- (void)inviteHelper:(PTKInviteHelper *)inviteHelper didSendInviteWithPresentedController:(UIViewController *)viewController phones:(NSArray *)phones {
    if (self.didPresentPostSignalNudge){
        self.didPresentPostSignalNudge = NO;
        [PTKEventTracker track:PTKEventTypeNudgeAfterSignalActionComplete withProperties:@{PTKEventPropertyKeyAction:PTKEventTypeNotRightNow}];
    }

    if (phones.count > 0) {
        [PTKEventTracker trackGraphInviteSentWithType:(inviteHelper.isServerSideSMS) ? kGRServerSMS : kGRSMS inviteType:kInviteTypeRoom roomId:self.roomId andAppLocation:kALPresence isContact:YES index:0];
        [PTKEventTracker trackGraphContactsInvitedWithType:(inviteHelper.isServerSideSMS) ? kGRServerSMS : kGRSMS inviteType:kInviteTypeRoom numberInvited:(int)phones.count roomId:self.roomId andAppLocation:kALPresence];
    }

    [viewController dismissViewControllerAnimated:YES completion:^{
        if (phones.count > 0) {
            NSString *title = (phones.count > 1 ? NSLocalizedString(@"Invites Sent", 0) : NSLocalizedString(@"Invite Sent", 0));
            NSString *message = (phones.count > 1 ? NSLocalizedString(@"Your invites have been sent! We will let you know when your friends join.", 0) : NSLocalizedString(@"Your invite has been sent! We will let you know when your friend joins.", 0));
            [PTKToastManager showToastWithTitle:title
                                        message:message
                                          image:[UIImage imageNamed:@"confirmation_checkmark"]
                                       subImage:nil
                                          onTap:nil];
        }
    }];
}

- (void)inviteHelper:(PTKInviteHelper *)inviteHelper didFailToSendWithPresentedController:(UIViewController *)viewController {
    if (self.didPresentPostSignalNudge){
        self.didPresentPostSignalNudge = NO;
        [PTKEventTracker track:PTKEventTypeNudgeAfterSignalActionComplete withProperties:@{PTKEventPropertyKeyAction:PTKEventTypeNotRightNow}];
    }

    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)inviteHelper:(PTKInviteHelper *)inviteHelper didCancelSendWithPresentedController:(UIViewController *)viewController {
    if (self.didPresentPostSignalNudge){
        self.didPresentPostSignalNudge = NO;
        [PTKEventTracker track:PTKEventTypeNudgeAfterSignalActionComplete withProperties:@{PTKEventPropertyKeyAction:PTKEventTypeNotRightNow}];
    }

    [PTKEventTracker trackGraphInviteCancelledWithType:(inviteHelper.isServerSideSMS) ? kGRServerSMS : kGRSMS inviteType:kInviteTypeRoom roomId:self.roomId andAppLocation:kALPresence];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
