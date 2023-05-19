//
//  PTKProfileAvatarViewController.h
//  portkey
//
//  Created by Adam Bellard on 5/4/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"
#import "PTKBlurView.h"

@interface PTKProfileAvatarViewController : PTKBaseViewController

- (instancetype)initWithUser:(PTKUser *)user;

@property (strong, nonatomic) PTKBlurView *blurView;
@property (nonatomic) NSString* phoneHash;

@end
