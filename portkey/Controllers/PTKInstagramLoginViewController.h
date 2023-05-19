//
//  PTKInstagramLoginViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 6/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@class PTKInstagramLoginViewController;
@protocol PTKInstagramLoginViewControllerDelegate <NSObject>

@optional

- (void)instagramLoginViewControllerDidLogin:(PTKInstagramLoginViewController *)loginViewController;

@end

@interface PTKInstagramLoginViewController : PTKBaseViewController

@property (nonatomic, weak) id<PTKInstagramLoginViewControllerDelegate> delegate;
- (void)showCloseButton;

@end
