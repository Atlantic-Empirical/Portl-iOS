//
//  UIApplication+PTK.h
//  portkey
//
//  Created by Daniel Amitay on 11/30/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (PTK)

- (BOOL)isTestFlightBuild;
- (BOOL)openAppStore;
- (BOOL)openTestFlight;

- (BOOL)openAppropriateUpdateChannel;

@end
