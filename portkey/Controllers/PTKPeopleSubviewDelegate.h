//
//  PTKPeopleSubviewDelegate.h
//  portkey
//
//  Created by Rodrigo Sieiro on 24/1/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKBaseViewController;
@protocol PTKPeopleSubviewDelegate <NSObject>

@required
- (BOOL)peopleSubview:(PTKBaseViewController *)subview isContactInvited:(PTKContact *)contact;

@optional
- (void)peopleSubviewDidScroll:(PTKBaseViewController *)subview;
- (void)peopleSubviewWantsToAddPeople:(PTKBaseViewController *)subview;
- (void)peopleSubview:(PTKBaseViewController *)subview showProfileForUser:(PTKUser *)user;
- (void)peopleSubview:(PTKBaseViewController *)subview removeFriendRequestForUser:(PTKUser *)user;
- (void)peopleSubview:(PTKBaseViewController *)subview addFriendRequestForUser:(PTKUser *)user;
- (void)peopleSubview:(PTKBaseViewController *)subview inviteContact:(PTKContact *)contact;

@end
