//
//  PTKProfileViewController+Data.h
//  portkey
//
//  Created by Robert Reeves on 3/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKProfileViewController.h"

@interface PTKProfileViewController (Data)

- (void)fetchUserProfileInformation;

- (void)onDidFetchUser:(PTKAPIResponse*)response;
- (void)updateUserProfileBioText:(NSString *)text;
- (void)onDidFetchRoomBasics:(PTKAPIResponse *)response;
- (void)onDidJoinRoom:(PTKAPIResponse*)response;

@end
