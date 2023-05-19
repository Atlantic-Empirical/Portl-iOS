//
//  PTKProfileViewController+View.h
//  portkey
//
//  Created by Robert Reeves on 3/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKProfileViewController.h"

@interface PTKProfileViewController (View)

- (void)loadViewContent;
- (void)updateViewForDisplay;
- (void)animateProfileIntoView;

- (void)updateBasicProfile;
- (void)updateUserBio;
- (void)updateStatusText;
- (void)updateFriendCount;
- (void)updateRoomCount;
- (void)updateActionButton;
- (void)updateFeaturedRooms;

- (void)showCancelAndDoneNavBar;
- (void)showDefaultNavBar;

@end
