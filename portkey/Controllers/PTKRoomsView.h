//
//  PTKRoomsView.h
//  portkey
//
//  Created by Seth Samuel on 1/10/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKRoomCollectionViewCell.h"

typedef enum : NSUInteger {
    PTKRoomsViewTypeFavorites,
    PTKRoomsViewTypeAll,
    PTKRoomsViewTypeLive,
    PTKRoomsViewTypeRecommended,
    PTKRoomsViewTypeMuted,
    PTKRoomsViewTypeSearch
} PTKRoomsViewType;

@interface PTKRoomsView : UIView <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, PTKPaginatedDataSourceDelegate, PTKRoomCollectionViewCellDelegate>
@property UIEdgeInsets contentInset;
@property PTKRoomsViewType type;
@property PTKRoomNavigationController *roomNavigationController;

- (instancetype)initWithType:(PTKRoomsViewType)type;
+ (NSString*) titleForType: (PTKRoomsViewType)type;

@property NSString *searchTerm;

- (void) reload;
- (void) scrollToUnreadRoom;

@end
