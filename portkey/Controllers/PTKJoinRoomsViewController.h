//
//  PTKJoinRoomsViewController.h
//  portkey
//
//  Created by Adam Bellard on 1/27/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTKJoinRoomsDelegate <NSObject>

- (void)joinInvitedRooms:(NSArray *)invites andRecommendedRooms:(NSArray *)recommendedRooms andRoomFromSlug:(PTKRoom *)room;

@end

@interface PTKJoinRoomsViewController : UIViewController

- (instancetype)initWithInvites:(NSArray *)invites andRecommendedRooms:(NSArray *)recommendedRooms;
- (instancetype)initWithRoomFromSlug:(PTKRoom *)room invites:(NSArray *)invites andRecommendedRooms:(NSArray *)recommendedRooms;

@property (nonatomic, weak) id<PTKJoinRoomsDelegate> delegate;

@end
