//
//  PTKRatingViewController.h
//  portkey
//
//  Created by Adam Bellard on 8/12/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKBaseViewController.h"

@interface PTKRatingViewController : PTKBaseViewController

@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *publishId;
@property (nonatomic, strong) NSString *subscribeId;

@end
