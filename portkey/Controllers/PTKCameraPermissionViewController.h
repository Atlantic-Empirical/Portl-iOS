//
//  PTKCameraPermissionViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 24/7/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKCameraPermissionViewController : UIViewController

@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) void (^completionBlock)(BOOL hasPermissionNow);

@end
