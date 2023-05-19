//
//  PTKOnboardingAddFriendsViewController.h
//  portkey
//
//  Created by Adam Bellard on 2/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKOnboardingBaseViewController.h"

@protocol PTKOnboardingAddFriendsViewControllerDelegate <NSObject>

- (void) onboardingAddFriendsDidComplete;

@end

@interface PTKOnboardingAddFriendsViewController : PTKOnboardingBaseViewController <UINavigationControllerDelegate>
@property (weak) id<PTKOnboardingAddFriendsViewControllerDelegate>delegate;
@end
