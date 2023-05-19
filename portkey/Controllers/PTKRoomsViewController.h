//
//  PTKRoomsViewController.h
//  portkey
//
//  Created by Seth Samuel on 1/10/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKBaseViewController.h"
#import "PTKRoomSearchNavigationBarView.h"

@interface PTKRoomsViewController : PTKBaseViewController <UIScrollViewDelegate, PTKRoomSearchNavigationBarViewDelegate, PTKPaginatedDataSourceDelegate>

- (void) showRoomInvites;
- (void) scrollToUnreadRoom;

@end
