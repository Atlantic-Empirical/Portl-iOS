//
//  PTKPermissionViewController.h
//  portkey
//
//  Created by Daniel Amitay on 5/5/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKInstructionsViewController.h"
#import "PTKPermissionManager.h"

@interface PTKPermissionViewController : PTKInstructionsViewController

- (instancetype)initWithPermissionType:(PTKPermissionType)permissionType;

@end
