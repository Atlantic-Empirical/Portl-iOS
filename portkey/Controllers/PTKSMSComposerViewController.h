//
//  PTKSMSComposerViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 23/2/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@class PTKSMSComposerViewController;
@protocol PTKSMSComposerViewControllerDelegate <NSObject>

@optional
- (void)smsComposerDidDismiss:(PTKSMSComposerViewController *)smsComposer;
- (void)smsComposer:(PTKSMSComposerViewController *)smsComposer didSendToContacts:(NSArray *)contacts;

@end

@interface PTKSMSComposerViewController : PTKBaseViewController

@property (nonatomic, weak) id<PTKSMSComposerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *requiredText;

@end
