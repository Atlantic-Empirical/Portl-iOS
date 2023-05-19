//
//  PTKRoomSearchView.h
//  portkey
//
//  Created by Seth Samuel on 1/16/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKRoomsView.h"
#import "PTKRoomSearchNavigationBarView.h"

@interface PTKRoomSearchView : UIView
@property NSString *searchTerm;
@property PTKRoomsView *roomsView;
@property PTKRoomSearchNavigationBarView *roomSearchNavigationBarView;

- (void) updateRecentSearches;
@end
