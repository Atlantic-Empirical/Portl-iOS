//
//  PTKProfileViewController+Actions.m
//  portkey
//
//  Created by Robert Reeves on 3/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKProfileViewController+Actions.h"
#import "PTKProfileListViewController.h"
#import "PTKProfileViewController+Data.h"
#import "PTKProfileViewController.h"
#import "PTKRoomCreatorRoomNameViewController.h"
#import "PTKProfileAvatarViewController.h"
#import "PTKAppSettingsViewController.h"
#import "PTKProfileViewController+View.h"
#import "SVWebViewControllerActivitySafari.h"
#import "PTKActivityViewController.h"

#import "PTKRoomCollectionViewCell.h"
#import "PTKProfileRoomsViewController.h"

@implementation PTKProfileViewController (Actions)

- (void)avatarImageAction:(id)sender {
    if (self.viewType == PTKProfileViewTypeOwn) {
        [PTKEventTracker track:PTKEventTypePeopleTabOPVPhotoTapped withProperties:nil];
    }

    if (![self isUserBlocked]) {
        PTKProfileAvatarViewController *profileAvatar = [[PTKProfileAvatarViewController alloc] initWithUser:self.user];
        profileAvatar.modalPresentationCapturesStatusBarAppearance = YES;
        profileAvatar.modalPresentationStyle = UIModalPresentationOverFullScreen;
        profileAvatar.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        profileAvatar.phoneHash = self.phoneHash;

        [self presentViewController:profileAvatar animated:YES completion:nil];
    }
}

- (void)friendsButtonAction:(id)sender {
    PTKProfileListViewController *vc = [[PTKProfileListViewController alloc] initWithFriends:self.friends withUser:self.user];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)roomsButtonAction:(id)sender {
    PTKProfileRoomsViewController *vc = [[PTKProfileRoomsViewController alloc] initWithRooms:self.publicRooms forUser:self.user];
    vc.delegate = self;
    vc.featureMode = NO;

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareButtonAction:(id)sender {
    [PTKEventTracker track:PTKEventTypePeopleTabOPVShareTapped withProperties:nil];

    NSString *inviteText = [PTKCopyHelper appInviteText];
    NSURL *url = [PTKCopyHelper fullUserUrl];
    NSArray *activityItems;

    if (url) {
        activityItems = @[inviteText, url];
    } else {
        activityItems = @[inviteText];
    }

    NSArray *activities = @[[SVWebViewControllerActivitySafari new]];
    PTKActivityViewController *activityController = [[PTKActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:activities];
    [activityController setValue:localizedString(@"Join me on Airtime!") forKey:@"Subject"];

    activityController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
        NSMutableDictionary* props = [NSMutableDictionary dictionaryWithCapacity:4];
        [props safeSetObject:activityType forKey:@"shareTarget"];
        [props safeSetObject:@"opv" forKey:@"appLocation"];
        [props safeSetObject:@"profile" forKey:@"shareType"];
        [props safeSetObject:@"link" forKey:@"shareAsset"];
        if (!completed) [props safeSetObject:(!NILORNULL(activityError) ? @"error" : @"cancelled") forKey:@"cause"];

        [PTKEventTracker track:(completed) ? PTKEventTypeGraphURLShared : PTKEventTypePeopleTabUrlShareFailed withProperties:props];
    };

    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)statusTextAction:(id)sender {
    if (self.roomUserIsIn) {
        [self joinRoom:self.roomUserIsIn];
    }
}

- (void)actionButtonAction:(id)sender {
    if ([self isUserBlocked]) {
        [self optionsButtonAction:nil];
    } else {
        if ([self.friendsDataSource hasOutgoingRequestForUserId:self.user.oid]) {
            [self.friendsDataSource removeFriendWithId:self.user.oid completion:nil];
        } else if (![self.friendsDataSource isMutualFriendWithUserId:self.user.oid]) {
            [self.friendsDataSource addFriendWithUser:self.user completion:nil];
        } else {
            PTKRoom *existingDM = [[PTKWeakSharingManager roomsDataSource] localExistingRoomWithUsers:@[self.user.userId, SELF_ID()] discoverable:NO requestToJoin:YES];

            if (!NILORNULL(existingDM)) {
                [self.roomNavigationController enterRoom:existingDM.oid withMessage:nil source:PTKRoomSourceTypeProfile animated:YES completion:nil];
            } else {
                [self showLoadingSpinner];

                [[PTKWeakSharingManager roomsDataSource] privateRoomWithUserId:self.user.userId completion:^(NSError *error, PTKRoom *room) {
                    [self hideSpinner];

                    if (error) {
                        [self showAlertWithTitle:NSLocalizedString(@"Error",0) andMessage:error.localizedDescription];
                    } else {
                        [self.roomNavigationController enterRoom:room.oid withMessage:nil source:PTKRoomSourceTypeProfile animated:YES completion:nil];
                    }
                }];
            }
        }
    }
}

#pragma mark - Navigation Bar

- (void)backButtonAction:(id)sender {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)settingsButtonAction:(id)sender {
    PTKAppSettingsViewController *settingsViewController = [[PTKAppSettingsViewController alloc] init];
    PTKNavigationController *nav = [[PTKNavigationController alloc] initWithRootViewController:settingsViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)optionsButtonAction:(id)sender {
    PTKActionSheetController *alert = [PTKActionSheetController actionSheetControllerWithTitle:nil message:nil];

    if ([self isUserBlocked]) {
        [alert addButtonWithTitle:NSLocalizedString(@"Unblock User",0) block:^{
            [[PTKWeakSharingManager blockedDataSource] unblockUser:self.user];
        }];
    } else {
        if ([self.friendsDataSource isMutualFriendWithUserId:self.user.oid]) {
            [alert addButtonWithTitle:NSLocalizedString(@"Remove Friend",0) block:^{
                [self.friendsDataSource removeFriendWithId:self.user.oid completion:nil];
            }];
        } else if ([self.friendsDataSource hasOutgoingRequestForUserId:self.user.oid]) {
            [alert addButtonWithTitle:NSLocalizedString(@"Cancel Friend Request",0) block:^{
                [self.friendsDataSource removeFriendWithId:self.user.oid completion:nil];
            }];
        } else if ([self.friendsDataSource hasIncomingRequestForUserId:self.user.oid]) {
            [alert addButtonWithTitle:NSLocalizedString(@"Accept Friend Request",0) block:^{
                [self.friendsDataSource addFriendWithUser:self.user completion:nil];
            }];
        } else if (![self isUserBlocked]) {
            [alert addButtonWithTitle:NSLocalizedString(@"Add Friend",0) block:^{
                [self.friendsDataSource addFriendWithUser:self.user completion:nil];
            }];
        }

        [alert addDestructiveButtonWithTitle:NSLocalizedString(@"Block",0) block:^{
            PTKAlertController *secondAlert = [PTKAlertController alertControllerWithTitle:NSLocalizedString(@"Block This Person",0) message:NSLocalizedString(@"Blocking this user will remove them from your friend list. They will be unable to invite you to rooms. You will not see their messages in any room you are both members of.", 0)];
            __block UITextField *textField = nil;

            [secondAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = NSLocalizedString(@"Reason for blocking?", nil);
                textField = textField;
            }];

            [secondAlert addButtonWithTitle:NSLocalizedString(@"Block",0) block:^{
                [PTKEventTracker track:PTKEventTypeUserBlocked withProperties:@{@"userId":self.user.userId, @"source": @"profile"}];
                [[PTKWeakSharingManager blockedDataSource] blockUser:self.user withReason:textField.text];
            }];

            [secondAlert addCancelButtonWithTitle:NSLocalizedString(@"Cancel",0) block:^{}];
            [self presentViewController:secondAlert animated:YES completion:nil];
        }];
    }

    [alert addCancelButtonWithTitle:NSLocalizedString(@"Cancel", 0) block:nil];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)cancelBioButtonAction:(id)sender {
    [self.bioTextView resignFirstResponder];
    self.bioTextView.text = self.oldBio;
}

- (void)doneBioButtonAction:(id)sender {
    if (self.bioTextView.text.length > kUPVMaxBioLength) {
        [self updateUserProfileBioText:[self.bioTextView.text substringToIndex:kUPVMaxBioLength]];
    } else {
        [self updateUserProfileBioText:self.bioTextView.text];
    }

    [self.bioTextView resignFirstResponder];
}

#pragma mark - Room Joining

- (void)joinRoom:(PTKRoom *)room {
    if ([[PTKWeakSharingManager roomsDataSource] objectWithId:room.oid]) {
        [self.roomNavigationController enterRoom:room.oid withMessage:nil source:PTKRoomSourceTypeProfile animated:YES completion:nil];
    } else  {
        [self fetchBasicsForRoom:room];
    }
}

- (void)fetchBasicsForRoom:(PTKRoom *)room {
    if (room) {
        [self showLoadingSpinner];
        PTKAPICallback *callback = [PTKAPI callbackWithTarget:self selector:@selector(onDidFetchRoomBasics:) userInfo:@{kKeyRoomTitle: room.roomDisplayName}];
        [PTKAPI fetchBasicsForRooms:@[room.oid] callback:callback];
    } else {
        [self showNoRoomActionSheetForRoom:nil withTitle:nil];
    }
}

- (void)showNoRoomActionSheetForRoom:(PTKRoom *)room withTitle:(NSString *)title {
    if (EMPTY_STR(title)) title = localizedString(@"this room");

    NSString *actionTitle = [NSString stringWithFormat:localizedString(@"You are not currently a member of %@."), title];
    NSString *message = nil;

    if (room.currentAccessibility != PTKRoomAccessibilityOpen && room.currentAccessibility != PTKRoomAccessibilityRequest) {
        message = localizedString(@"This room requires an invitation to join.");
    }

    PTKActionSheetController *actionSheet = [PTKActionSheetController actionSheetControllerWithTitle:actionTitle message:message];

    if (room.currentAccessibility == PTKRoomAccessibilityRequest) {
        [actionSheet addButtonWithTitle:localizedString(@"Request access to the room") block:^{
            [self showLoadingSpinner];
            PTKAPICallback *callback = [PTKAPI callbackWithTarget:self selector:@selector(onDidJoinRoom:) userInfo:@{kKeyRoom: room}];
            [PTKAPI joinRoom:room.oid callback:callback];
        }];
    } else if (room.currentAccessibility == PTKRoomAccessibilityOpen) {
        [actionSheet addButtonWithTitle:localizedString(@"Join the room and enter now") block:^{
            [self showLoadingSpinner];
            PTKAPICallback *callback = [PTKAPI callbackWithTarget:self selector:@selector(onDidJoinRoom:) userInfo:@{kKeyRoom: room}];
            [PTKAPI joinRoom:room.oid callback:callback];
        }];
    }

    [actionSheet addCancelButtonWithTitle:localizedString(@"Cancel")];

    [self hideSpinner];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - PTKPaginatedDataSourceDelegate

- (void)paginatedDataSourceDidLoad:(PTKPaginatedDataSource *)dataSource {
    if (dataSource == self.friendsDataSource) {
        if (self.viewType == PTKProfileViewTypeOwn) {
            self.friends = self.friendsDataSource.allObjects;
            self.totalFriends = (int)self.friends.count;
        }

        [self updateStatusText];
        [self updateFriendCount];
        [self updateRoomCount];
        [self updateActionButton];
        [self updateFeaturedRooms];
    } else if (dataSource == self.roomsDataSource && self.viewType == PTKProfileViewTypeOwn) {
        self.publicRooms = self.roomsDataSource.allObjects;
        self.featuredRooms = self.roomsDataSource.featuredRooms;
        self.totalPublicRooms = (int)self.publicRooms.count;

        [self updateRoomCount];
        [self updateFeaturedRooms];
    }
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.viewType == PTKProfileViewTypeOwn) {
        if (self.featuredRooms.count > 0) {
            // add 2 cells for "add button cells", to be placed at the beginning and end of scroll
            return self.featuredRooms.count + 2;
        } else {
            // 3 total, if there are 0 rooms, to have a minimum 3 for design reqs
            return 3;
        }
    } else {
        return self.featuredRooms.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewType == PTKProfileViewTypeOwn && (indexPath.item == 0 || indexPath.item > self.featuredRooms.count)) {
        return [collectionView dequeueReusableCellWithReuseIdentifier:kUPVRoomAddCellIdentifier forIndexPath:indexPath];
    }

    return [collectionView dequeueReusableCellWithReuseIdentifier:kUPVRoomCellIdentifier forIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(PTKRoomCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.oneLineTitle = YES;
    cell.hideBadges = YES;
    cell.hideMoreButton = (self.viewType == PTKProfileViewTypeNormal);

    if (self.viewType == PTKProfileViewTypeOwn && indexPath.item > 0 && indexPath.item <= self.featuredRooms.count) {
        cell.room = self.featuredRooms[indexPath.item - 1];
    } else if (self.viewType == PTKProfileViewTypeNormal) {
        cell.room = self.featuredRooms[indexPath.item];
    } else {
        cell.room = nil;
    }

    cell.delegate = self;
    [cell willDisplayCell];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewType == PTKProfileViewTypeOwn && indexPath.item > 0 && indexPath.item <= self.featuredRooms.count) {
        [self joinRoom:self.featuredRooms[indexPath.item - 1]];
    } else if (self.viewType == PTKProfileViewTypeNormal) {
        [self joinRoom:self.featuredRooms[indexPath.item]];
    } else {
        NSArray *rooms = [PTKWeakSharingManager roomsDataSource].featureableRooms;
        PTKProfileRoomsViewController *vc = [[PTKProfileRoomsViewController alloc] initWithRooms:rooms forUser:self.user];
        vc.delegate = self;
        vc.featureMode = YES;

        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - PTKRoomCollectionViewCellDelegate

- (void)roomCollectionViewCell:(PTKRoomCollectionViewCell *)cell didRequestMoreMenuAtPoint:(CGPoint)point {
    PTKActionSheetController *alert = [PTKActionSheetController actionSheetControllerWithTitle:cell.room.roomDisplayName message:nil];

    [alert addDestructiveButtonWithTitle:NSLocalizedString(@"Remove Featured Room",0) block:^{
        [self.roomsDataSource removeFeaturedRoomWithId:cell.room.oid];
    }];

    [alert addCancelButtonWithTitle:NSLocalizedString(@"Cancel", 0) block:nil];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self showCancelAndDoneNavBar];

    self.oldBio = textView.text;
    textView.text = [textView.text stringByTrimmingWhiteSpace];

    [UIView animateWithDuration:0.3f animations:^{
        self.bioPlaceholderView.alpha = 0;
    }];

    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self showDefaultNavBar];

    if (textView.text.length == 0) {
        [UIView animateWithDuration:0.3f animations:^{
            self.bioPlaceholderView.alpha = 0.7f;
        }];
    }

    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];

        if (textView.text.length > kUPVMaxBioLength)
            [self updateUserProfileBioText:[textView.text substringToIndex:kUPVMaxBioLength]];
        else
            [self updateUserProfileBioText:textView.text];
    }

    if (textView.text.length >= kUPVMaxBioLength && text.length > 0) {
        return NO;
    }

    return YES;
}

#pragma mark - PTKOnlinePresenceDataSourceDelegate

- (void)onlinePresenceDataSourceDidChange:(PTKOnlinePresenceDataSource *)dataSource {
    [self updateStatusText];
}

#pragma mark - PTKProfileRoomsViewControllerDelegate

- (void)profileRoomsDidFeatureRoom:(PTKRoom *)room {
    if (!room) return;
    [self.roomsDataSource featureRoomWithId:room.oid];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)profileRoomsDidSelectRoom:(PTKRoom *)room {
    if (!room) return;
    [self joinRoom:room];
}

#pragma mark - Notifications

- (void)onDidBlockOrUnblockUser:(NSNotification *)n {
    NSString *userId = n.userInfo[kKeyUserId];

    if ([userId isEqualToString:self.user.oid]) {
        [self updateFriendCount];
        [self updateRoomCount];
        [self updateActionButton];
        [self animateProfileIntoView];
    }
}

@end
