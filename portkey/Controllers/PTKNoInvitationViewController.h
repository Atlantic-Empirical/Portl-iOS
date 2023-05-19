//
//  PTKNoInvitationViewController.h
//  portkey
//
//  Created by Daniel Amitay on 5/5/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKInstructionsViewController.h"

@class PTKNoInvitationViewController;
@protocol PTKNoInvitationViewControllerDelegate <NSObject>

@required
- (void)noInvitationControllerWantsDefaultScreen:(PTKNoInvitationViewController *)controller;
- (void)noInvitationControllerWantsPhoneInput:(PTKNoInvitationViewController *)controller;
- (void)noInvitationControllerWantsSessionRefresh:(PTKNoInvitationViewController *)controller;

@end

@interface PTKNoInvitationViewController : PTKInstructionsViewController

@property (nonatomic, weak) id <PTKNoInvitationViewControllerDelegate> delegate;

@end
