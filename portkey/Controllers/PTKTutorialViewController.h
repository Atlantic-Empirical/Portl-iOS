//
//  PTKTutorialViewController.h
//  portkey
//
//  Created by Robert Reeves on 10/16/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@protocol PTKTutorialViewControllerDelegate <NSObject>

@optional

- (void)userDidTapGetStarted;

@end

@interface PTKTutorialViewController : PTKBaseViewController

@property (nonatomic, weak) id<PTKTutorialViewControllerDelegate> delegate;

@end
