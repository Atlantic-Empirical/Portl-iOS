//
//  PTKActivitiesListViewController.m
//  portkey
//
//  Created by Adam Bellard on 10/29/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import "PTKCardStackViewController.h"
#import "PTKActivitiesListViewController.h"
#import "PTKActivityCell.h"
#import "PTKPhotosMessage.h"
#import "PTKVideoMessage.h"
#import "PTKProfileViewController.h"
#import "PTKYoutubeMessage.h"
#import "PTKActivitiesDataSource.h"

@interface PTKActivitiesListViewController () <UITableViewDelegate, UITableViewDataSource, PTKPaginatedDataSourceDelegate, PTKActivityCellDelegate, PTKCardStackViewControllerDelegate> {
    NSArray *_activites;
    PTKActivitiesDataSource *_activitiesDataSource;
    NSDate *_lastViewedActivity, *_lastActivity, *_lastActivityWhenLeaving;
    UIView *_noDataView;
}

@end

@implementation PTKActivitiesListViewController

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    _activitiesDataSource = [PTKWeakSharingManager activitiesDataSource];
    [_activitiesDataSource registerDelegate:self];
    [_activitiesDataSource reload];

    _lastViewedActivity = [PTKUserDefaults lastViewedActivity];
    _lastActivityWhenLeaving = _lastViewedActivity;

    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [PTKColor almostWhiteColor];

    [self.tableView registerClass:[PTKActivityCell class] forCellReuseIdentifier:@"PTKActivityCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self listenFor:UIApplicationWillEnterForegroundNotification selector:@selector(onWillEnterForeground:)];
    [self listenFor:kNotificationActivityUpdated selector:@selector(onActivityUpdated:)];
    [self listenFor:kNotificationFriendAdded selector:@selector(onFriendAdded:)];
    [self listenFor:kNotificationFriendRemoved selector:@selector(onFriendRemoved:)];

    _noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 290.0f)];
    _noDataView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    UIImageView *activityLogo = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _noDataView.width, 145.0f)];
    activityLogo.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    activityLogo.contentMode = UIViewContentModeCenter;
    activityLogo.image = [[UIImage imageNamed:@"no-activity"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    activityLogo.tintColor = [PTKColor brandColor];
    [_noDataView addSubview:activityLogo];

    UILabel *noActivityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 145.0f, _noDataView.width, 75.0f)];
    noActivityLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    noActivityLabel.textAlignment = NSTextAlignmentCenter;
    noActivityLabel.numberOfLines = 2;
    noActivityLabel.font = [PTKFont boldFontOfSize:30.0f];
    noActivityLabel.textColor = [PTKColor brandColor];
    noActivityLabel.text = NSLocalizedString(@"You don't have any\nactivity just yet.", 0);
    [_noDataView addSubview:noActivityLabel];

    [self paginatedDataSourceDidLoad:_activitiesDataSource];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [PTKColor brandColor]}];

    [self maybeReloadDataSources];
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Loop through the activities to calculate the unread count
    NSInteger unreadCount = 0;
    for (PTKActivity *activity in _activites) {
        if (!_lastActivityWhenLeaving || (activity.createdAt && [_lastActivityWhenLeaving timeIntervalSinceDate:activity.createdAt] < 0.0f)) {
            unreadCount++;
        }
    }
    
    // Track the amount of unread activities and the total amount of activities in the list
    NSString *activitiesCount = [NSString stringWithFormat:@"%lu", (unsigned long)_activites.count];
    [PTKEventTracker track:PTKEventTypeActivityScreenLoaded withProperties:@{@"numUnread": @(unreadCount), @"numItems":activitiesCount}];

    
    _lastViewedActivity = _lastActivity;
    [PTKUserDefaults setLastViewedActivity:_lastViewedActivity];

    [self.tabBarController.tabBar setValue:nil forBadgeAtIndex:1];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    _lastActivityWhenLeaving = _lastActivity;
    self.tableView.contentOffset = CGPointZero;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (_noDataView.superview == self.view) {
        _noDataView.frame = CGRectMake(0, ceilcg(self.view.height / 2.0f) - ceilcg(_noDataView.height / 2.0f), self.view.width, _noDataView.height);
    }
}

- (void)maybeReloadDataSources {
    // Only reload if we're visible
    if (self.viewIsVisible) {
        // Do not reload if the last reload was less than 2 minutes ago
        if (!_activitiesDataSource.lastReload || [[NSDate date] timeIntervalSinceDate:_activitiesDataSource.lastReload] >= 120) { // 2 minutes
            [_activitiesDataSource reload];
        }
    }
}

#pragma mark - UITableViewDataSource / UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _activites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PTKActivity *activity = _activites[indexPath.row];
    PTKActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PTKActivityCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.activity = activity;
    
    NSDate *activityCreatedAt = activity.createdAt;
    if (!_lastActivityWhenLeaving || (activityCreatedAt && [_lastActivityWhenLeaving timeIntervalSinceDate:activityCreatedAt] < 0.0f)) {
        cell.contentView.backgroundColor = [PTKColor almostWhiteColor];
    } else {
        cell.contentView.backgroundColor = [PTKColor almostWhiteColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PTKActivity *activity = [_activites objectAtIndex:indexPath.row];
    NSString *dateCreated = [NSDateFormatter localizedStringFromDate:activity.createdAt dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterFullStyle];
    
    // Track the activity
    NSMutableDictionary* trackDict = [NSMutableDictionary dictionaryWithCapacity:4];
    [trackDict safeSetObject:activity.oid forKey:@"activityId"];
    [trackDict safeSetObject:activity.activityString forKey:@"activityType"];
    [trackDict safeSetObject:@(indexPath.row) forKey:@"position"];
    [trackDict safeSetObject:dateCreated forKey:@"dateCreated"];
    
    [PTKEventTracker track:PTKEventTypeActivityTapped withProperties:trackDict];

    if (activity.type == PTKActivityTypeRoomRecommended) {
        [self showLoadingSpinner];
        PTKAPICallback *callback = [PTKAPI callbackWithTarget:self selector:@selector(onDidJoinRoom:) userInfo:@{kKeyRoom: activity.room}];
        [PTKAPI joinRoom:activity.room.oid callback:callback];
    } else if (activity.room) {
        if (activity.room.pending) {
            PTKCardStackViewController *roomPop = [[PTKCardStackViewController alloc] initWithUnderlyingBlurView:self.tabBarController.view withMasterCardColor:nil withAutoEnterRoomOnEntry:YES];
            roomPop.delegate = self;
            roomPop.modalPresentationStyle = UIModalPresentationOverFullScreen;
            roomPop.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [roomPop presentCardsWithObjects:@[activity.room] firstRoom:nil];
        } else {
            PTKRoom *room = [[PTKWeakSharingManager roomsDataSource] objectWithId:activity.room.oid];
            if (!room) {
                [self showLoadingSpinner];
            }

            [self.roomNavigationController enterRoom:activity.room.oid withMessage:activity.message source:PTKRoomSourceTypeActivity animated:YES completion:^(NSError *error){
                if (error) {
                    [self fetchBasicsForRoom:activity.room];
                } else {
                    [self hideSpinner];
                }
            }];
        }
    } else if (activity.type == PTKActivityTypeFriendAdded || activity.type == PTKActivityTypeContactJoined) {
        PTKProfileViewController *profile = [[PTKProfileViewController alloc] initWithUser:activity.user];
        [self.navigationController pushViewController:profile animated:YES];
    } else {
        [self showNoRoomActionSheetForRoom:nil withTitle:nil];
    }
}

- (void)fetchBasicsForRoom:(PTKRoom *)room {
    if (room) {
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

#pragma mark - PTKPaginatedDataSource methods

- (void)paginatedDataSourceDidLoad:(PTKPaginatedDataSource *)dataSource {
    if (dataSource == _activitiesDataSource) {
        _activites = dataSource.allObjects;
        [self reloadData];
    }
}

- (void)reloadData {
    NSInteger unseenCount = 0;

    for (PTKActivity *activity in _activites) {
        NSDate *activityCreatedAt = activity.createdAt;

        if (!_lastViewedActivity || (activityCreatedAt && [_lastViewedActivity timeIntervalSinceDate:activityCreatedAt] < 0.0f)) {
            unseenCount++;
        }

        if (!_lastActivity || [_lastActivity timeIntervalSinceDate:activityCreatedAt] < 0.0f) {
            _lastActivity = activityCreatedAt;
        }
    }

    BOOL visible = self.isViewLoaded && self.view.window && self.roomNavigationController.visiblePage != PTKNavigationStateRoom;

    if (unseenCount > 0 && !visible) {
        if (kFeatureShouldBadgeAsDots) {
            [self.tabBarController.tabBar setValue:@"" forBadgeAtIndex:1];
        } else {
            NSString *badgeValue = [NSString stringWithFormat:@"%d", (int)unseenCount];
            [self.tabBarController.tabBar setValue:badgeValue forBadgeAtIndex:1];
        }
    } else {
        [self.tabBarController.tabBar setValue:nil forBadgeAtIndex:1];
    }

    if (!self.viewIsVisible && !self.viewIsAppearing) return;

    if (visible) {
        _lastViewedActivity = _lastActivity;
        [PTKUserDefaults setLastViewedActivity:_lastViewedActivity];
    }

    __weak typeof(self) weakSelf = self;

    void (^animationBlock)() = ^(){
        typeof(self) strongSelf = weakSelf;
        if (!strongSelf) return;

        if (strongSelf->_activites.count == 0) {
            strongSelf.tableView.tableHeaderView = nil;
            [strongSelf.view addSubview:strongSelf->_noDataView];
            strongSelf->_noDataView.frame = CGRectMake(0, ceilcg(strongSelf.view.height / 2.0f) - ceilcg(strongSelf->_noDataView.height / 2.0f), strongSelf.view.width, strongSelf->_noDataView.height);
        } else {
            strongSelf.tableView.tableHeaderView = nil;
            [strongSelf->_noDataView removeFromSuperview];
        }

        [strongSelf.tableView reloadData];
    };

    // Only animate the table reload if the scrollview is not moving
    BOOL animated = (!self.tableView.isDecelerating && !self.tableView.isDragging);

    if (animated) {
        [UIView transitionWithView:self.tableView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction
                        animations:animationBlock
                        completion:nil];
    } else {
        animationBlock();
    }
}

- (void)onDidJoinRoom:(PTKAPIResponse *)response {
    [self hideSpinner];

    if (!response.error) {
        PTKRoom *room = response.userInfo[kKeyRoom];
        NSString *state = response.JSON[@"state"];
        if (!room) return;

        if ([state isEqualToString:@"requested"]) {
            [PTKEventTracker track:PTKEventTypeRoomManagerRTJRequest withProperties:@{@"userId": SELF_ID(), @"roomId": room.oid}];
            [PTKToastManager showToastWithTitle:room.roomDisplayName message:localizedString(@"you requested access to join") image:nil subImage:nil onTap:nil];
        } else  {
            // Room is not RTE, enter immediately
            [self.roomNavigationController enterRoom:room.oid withMessage:nil source:PTKRoomSourceTypeActivity animated:YES completion:nil];
        }

        [[PTKWeakSharingManager recommendedRoomsDataSource] removeObjectWithId:room.oid completion:nil];
    } else {
        PTKLogError(@"Failed to join room: %@", response.error);
    }
}

- (void)onDidFetchRoomBasics:(PTKAPIResponse *)response {
    NSString *roomTitle = response.userInfo[kKeyRoomTitle];
    PTKRoom *room = nil;

    if (response.error) {
        PTKLogError(@"Error: %@", response.error);
    }

    if (response.JSON && [response.JSON isKindOfClass:[NSArray class]]) {
        room = [[PTKRoom alloc] initWithJSON:response.JSON[0]];
    }

    [self showNoRoomActionSheetForRoom:room withTitle:roomTitle];
}

#pragma mark - PTKCardStackViewControllerDelegate methods

- (void)roomInvitesViewControllerNeedsPresentation:(PTKCardStackViewController *)recommendedRoomViewController {
    [self presentViewController:recommendedRoomViewController animated:YES completion:nil];
}

- (void)roomInvitesViewControllerNeedsDismissal:(PTKCardStackViewController *)recommendedRoomViewController {
    [recommendedRoomViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)roomInvitesViewControllerRoomJoined:(NSString *)roomId {
    WEAK_SELF
    [self dismissViewControllerAnimated:YES completion:^{
        STRONG_SELF
        if (roomId) {
            [self showLoadingSpinner];
            PTKAPICallback *callback = [PTKAPI callbackWithTarget:self selector:@selector(onDidAcceptPendingRoom:)];
            callback.userInfo = @{kKeyRoomId: roomId};
            [[PTKWeakSharingManager roomsDataSource] acceptPendingRoom:roomId callback:callback];
        }
    }];
}

#pragma mark - PTKActivityCellDelegate

- (void)userDidTapAvatar:(PTKUser*)user {
    if (!user) {
        return;
    }
    
    PTKProfileViewController *profile = [[PTKProfileViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:profile animated:YES];
}

- (void)userDidTapInfoImageWith:(PTKActivityCell *)activityCell {
    if (!activityCell.activity) {
        return;
    }
    
    if (activityCell.activity.type == PTKActivityTypeFriendAdded) {
        [PTKEventTracker track:PTKEventTypeGraphFriendAccepted withProperties:@{@"appLocation": kALActivity} ];
    }
    
    if (activityCell.activity.type == PTKActivityTypeContactJoined) {
        [PTKEventTracker track:PTKEventTypeGraphFriendAdded withProperties:@{@"appLocation": kALActivity} ];
    }
    
    if (activityCell.activity.type == PTKActivityTypeFriendAdded  || activityCell.activity.type == PTKActivityTypeContactJoined) {
        __weak typeof(self) weakSelf = self;

        [[PTKWeakSharingManager friendsDataSource] addFriendWithUser:activityCell.activity.user completion:^(NSError *error) {
            typeof(self) strongSelf = weakSelf;
            if (!strongSelf) return;

            if (error) {
                [strongSelf showAlertWithTitle:NSLocalizedString(@"Error", 0) andMessage:error.localizedDescription];
            }
        }];
    }
}

- (void)userDidAcceptPendingRoom:(PTKRoom *)pendingRoom {
    [self showLoadingSpinner];

    PTKAPICallback *callback = [PTKAPI callbackWithTarget:self selector:@selector(onDidAcceptPendingRoom:)];
    callback.userInfo = @{kKeyRoomId: pendingRoom.oid};
    [[PTKWeakSharingManager roomsDataSource] acceptPendingRoom:pendingRoom.oid callback:callback];
}

- (void)userDidDismissPendingRoom:(PTKRoom *)pendingRoom {
    [[PTKWeakSharingManager roomsDataSource] dismissPendingRoom:pendingRoom.oid callback:nil];
}

- (void)onDidAcceptPendingRoom:(PTKAPIResponse *)response {
    [self hideSpinner];

    NSString *roomId = response.userInfo[kKeyRoomId];

    if (roomId) {
        [self.roomNavigationController enterRoom:roomId withMessage:nil source:PTKRoomSourceTypeActivity animated:YES completion:nil];
    }
}

#pragma mark - Notifications

- (void)onWillEnterForeground:(NSNotification *)n {
    [self performSelector:@selector(maybeReloadDataSources) withObject:nil afterDelay:1.0f];
}

- (void)onActivityUpdated:(NSNotification *)n {
    // We have new activity
    [_activitiesDataSource reload];
}

- (void)onFriendAdded:(NSNotification *)n {
    // A friend was added, refresh the UI
    [self reloadData];
}

- (void)onFriendRemoved:(NSNotification *)n {
    // A friend was removed, refresh the UI
    [self reloadData];
}

@end
