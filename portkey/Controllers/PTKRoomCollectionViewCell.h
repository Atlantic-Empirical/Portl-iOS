//
//  PTKRoomCollectionViewCell.h
//  portkey
//
//  Created by Seth Samuel on 1/10/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKRoomCollectionViewCell;

@protocol PTKRoomCollectionViewCellDelegate <NSObject>
- (void) roomCollectionViewCell:(PTKRoomCollectionViewCell*) cell didRequestMoreMenuAtPoint:(CGPoint) point;
@end

@interface PTKRoomCollectionViewCell : UICollectionViewCell
@property (weak) id<PTKRoomCollectionViewCellDelegate> delegate;
@property PTKRoom *room;
@property CGFloat width;
@property BOOL oneLineTitle;
@property BOOL shouldDisplayLive;
@property BOOL hideMoreButton;
@property BOOL hideBadges;

- (void) willDisplayCell;
- (CGFloat) heightThatFits;
+ (CGFloat)heightForRoom:(PTKRoom *)room withWidth:(CGFloat)width;

@end
