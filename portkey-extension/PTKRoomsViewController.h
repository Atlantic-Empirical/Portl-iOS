//
//  PTKRoomsViewController.h
//  portkey-extension
//
//  Created by Rodrigo Sieiro on 5/8/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKRoomsViewController, PTKRoom;
@protocol PTKRoomsViewControllerDelegate <NSObject>

@optional
- (void)roomsViewController:(PTKRoomsViewController *)roomsViewController didSelectRoom:(PTKRoom *)room;

@end

@interface PTKRoomsViewController : UITableViewController

@property (nonatomic, weak) id<PTKRoomsViewControllerDelegate> delegate;

- (instancetype)initWithRooms:(NSArray *)rooms;

@end
