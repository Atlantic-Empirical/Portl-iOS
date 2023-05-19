//
//  PTKAvatarCloudView.h
//  portkey
//
//  Created by Adam Bellard on 3/13/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKAvatarCloudView : UIView

@property (nonatomic, strong) NSArray *userIds;
@property (nonatomic, strong) NSArray *avatarLocations;
@property (nonatomic, strong) NSArray *avatarSizes;

- (void)loadAvatars;
- (NSArray *)avatarViews;

+ (NSArray *)superSignalUserIdsForRoom:(NSString *)roomId;

@end
