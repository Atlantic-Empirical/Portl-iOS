//
//  PTKProfileViewController+Data.m
//  portkey
//
//  Created by Robert Reeves on 3/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "NSString+Util.h"
#import "PTKProfileViewController+Data.h"
#import "PTKProfileViewController+View.h"
#import "PTKProfileViewController+Actions.h"
#import "PTKPermissionManager.h"
#import "PTKOnlinePresenceDataSource.h"

@implementation PTKProfileViewController (Data)

#pragma mark - PTKAPI

- (void)fetchUserProfileInformation {
    if (!self.user.userId) return;

    if (self.viewType == PTKProfileViewTypeOwn) {
        [self parseOwnUserData];
    } else {
        if (!self.onlinePresence) {
            self.onlinePresence = [[PTKOnlinePresenceDataSource alloc] init];
            self.onlinePresence.delegate = self;
            [self.onlinePresence setObservingUserIds:[NSSet setWithObject:self.user.userId]];
        }

        [self updateBasicProfile];

        PTKAPICallback *fetchCallback = [PTKAPI callbackWithTarget:self selector:@selector(onDidFetchUser:)];
        [PTKAPI fetchUser:self.user.userId withPresenceAndRoomInfo:YES skip:0 limit:kUPVListsLimit withCallback:fetchCallback];
    }
}

- (void)updateUserProfileBioText:(NSString*)text {
    NSDictionary *params = @{@"bio": text};
    PTKAPICallback *callback = [PTKAPI callbackWithTarget:self selector:@selector(onDidUpdateUserProperties:)];
    [PTKAPI updateUserProperties:params callback:callback];
}

#pragma mark - User Profile Parsers

- (void)parseOwnUserData {
    self.publicRooms = self.roomsDataSource.allObjects;
    self.featuredRooms = self.roomsDataSource.featuredRooms;
    self.friends = self.friendsDataSource.allObjects;
    self.sharedRooms = nil;
    self.mutualFriends = nil;
    self.totalPublicRooms = (int)self.publicRooms.count;
    self.totalFriends = (int)self.friends.count;
    self.totalSharedRooms = 0;
    self.totalMutualFriends = 0;

    [self updateViewForDisplay];
}

- (void)parseUserData:(NSDictionary *)json {
    if (![json isKindOfClass:[NSDictionary class]]) return;

    PTKUser *user = [[PTKUser alloc] initWithJSON:json];

    if (user && self.user.lastSeenAt && !user.lastSeenAt) {
        user = [user copyWithLastSeenAt:self.user.lastSeenAt];
    }

    if (user) self.user = user;
}

- (void)parseUserPresence:(id)presence {
    if ([presence isKindOfClass:[NSDictionary class]]) {
        [[PTKOnlinePresenceMaster shared] setUserOnline:self.user.oid withRoom:[[PTKRoom alloc] initWithJSON:presence]];
    } else if ([presence isKindOfClass:[NSString class]] && [presence isEqualToString:@"online"]) {
        [[PTKOnlinePresenceMaster shared] setUserOnline:self.user.oid withRoom:nil];
    }
}

- (void)parseUserPhone:(NSString *)phone {
    self.phoneHash = phone;
}

- (void)parseSharedRooms:(NSDictionary *)json {
    NSArray *rooms = json[@"results"];
    NSMutableArray *sharedRooms = [NSMutableArray arrayWithCapacity:rooms.count];

    for (NSDictionary *json in rooms) {
        PTKRoom *room = [[PTKRoom alloc] initWithJSON:json];

        if (room) {
            [sharedRooms addObject:room];
        }
    }

    self.totalSharedRooms = [json[@"total"] intValue];
    self.sharedRooms = sharedRooms;
}

- (void)parsePublicRooms:(NSDictionary *)json {
    NSArray *rooms = json[@"results"];
    NSMutableArray *publicRooms = [NSMutableArray arrayWithCapacity:rooms.count];
    NSMutableArray *featuredRooms = [NSMutableArray arrayWithCapacity:rooms.count];

    for (NSDictionary *json in rooms) {
        PTKRoom *room = [[PTKRoom alloc] initWithJSON:json];

        if (room) {
            [publicRooms addObject:room];
            if (room.feature) [featuredRooms addObject:room];
        }
    }

    self.totalPublicRooms = [json[@"total"] intValue];
    self.publicRooms = publicRooms;
    self.featuredRooms = featuredRooms;
}

- (void)parseMutualFriends:(NSDictionary *)json {
    self.totalMutualFriends = [json[@"total"] intValue];
    self.mutualFriends = json[@"results"];
}

- (void)parseUserFriends:(NSDictionary *)json {
    NSArray *users = json[@"results"];
    NSMutableArray *friends = [NSMutableArray arrayWithCapacity:users.count];

    for (NSDictionary *json in users) {
        PTKUser *user = [[PTKUser alloc] initWithJSON:json];

        if (user) {
            [friends addObject:user];
        }
    }

    self.totalFriends = [json[@"total"] intValue];
    self.friends = friends;
}


#pragma mark - PTKAPIResponse

- (void)onDidFetchUser:(PTKAPIResponse *)response {
    if (response.error) {
        PTKLogError(@"User Fetch Error: %@", response.error);

        [self updateViewForDisplay];
        return;
    }

    if (![response.JSON isKindOfClass:[NSArray class]]) {
        [self updateViewForDisplay];
        return;
    }

    NSArray *results = response.JSON;

    for (NSDictionary *json in results) {
        NSString *path = json[@"pathKey"];
        id value = json[@"value"];

        if (EMPTY_STR(path)) {
            [self parseUserData:value];
        } else if ([path isEqualToString:@"presence"]) {
            [self parseUserPresence:value];
        } else if ([path isEqualToString:@"phone"]) {
            [self parseUserPhone:value];
        } else if ([path isEqualToString:@"shared"]) {
            [self parseSharedRooms:value];
        } else if ([path isEqualToString:@"rooms"]) {
            [self parsePublicRooms:value];
        } else if ([path isEqualToString:@"mutual"]) {
            [self parseMutualFriends:value];
        } else if ([path isEqualToString:@"friends"]) {
            [self parseUserFriends:value];
        }
    }

    [self updateViewForDisplay];
}

- (void)onDidUpdateUserProperties:(PTKAPIResponse *)response {
    
    if (response.error) {
        [self showAlertWithTitle:NSLocalizedString(@"Error", 0) andMessage:response.error.localizedDescription];
        return;
    }
    
    [PTKData sharedInstance].session = [[PTKSession alloc] initWithJSON:response.JSON];
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

@end
