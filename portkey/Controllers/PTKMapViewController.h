//
//  PTKMapViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 6/7/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"
#import "PTKPlaceMessage.h"

@class CLLocation;


@protocol PTKMapViewControllerDelegate <NSObject>

- (void)userDidCloseMapController:(PTKPlaceMessage*)withMessage;;

@end



@interface PTKMapViewController : PTKBaseViewController

@property (nonatomic, weak) id<PTKMapViewControllerDelegate> delegate;
@property (nonatomic, strong) PTKPlaceMessage *message;

- (instancetype)initWithMessage:(PTKPlaceMessage *)message;
- (void)updateInteractionState:(BOOL)interaction;


@end
