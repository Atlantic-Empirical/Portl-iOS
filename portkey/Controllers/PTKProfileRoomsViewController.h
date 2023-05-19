//
//  PTKProfileRoomsViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 28/2/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@protocol PTKProfileRoomsViewControllerDelegate <NSObject>

@optional
- (void)profileRoomsDidFeatureRoom:(PTKRoom *)room;
- (void)profileRoomsDidSelectRoom:(PTKRoom *)room;

@end

@interface PTKProfileRoomsViewController : PTKBaseViewController

@property (nonatomic, weak) id<PTKProfileRoomsViewControllerDelegate> delegate;
@property (nonatomic) BOOL featureMode;

- (instancetype)initWithRooms:(NSArray *)rooms forUser:(PTKUser *)user;

@end
