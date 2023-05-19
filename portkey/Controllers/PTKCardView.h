//
//  PTKCardView.h
//  portkey
//
//  Created by Robert Reeves on 3/25/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKRoom.h"
#import "PTKUser.h"

@interface PTKCardView : UIView


/**
 returns members copy for the bottom of room card views
 @param CGRect frame for card view
 @param UIColor optional master color that will override room & user background colors
        that can be updated after init
 @return PTKCardView default initialiation
 */
- (id)initWithFrame:(CGRect)frame withMasterCardColor:(UIColor*)color;


/**
 returns members copy for the bottom of room card views
 @param PTKRoom the room object for the room card
 @return NSString formatted members copy for a label
 */
- (void)updateViewWithObject:(id)object;



#pragma mark - 

/**
 dark overlay with image & copy fades over selected card, as user drags it right or left
 */
@property (nonatomic) UIView* blackOverlayView;


/**
 room object used to populate this card's contents
 */
@property (nonatomic) PTKRoom* room;


/**
 user object to populate this card's contents
 */
@property (nonatomic) PTKUser* user;


/**
 image icon that appears (fades) in as the user drags a card & commits to a decline or accept action
 */
@property (nonatomic) PTKImageView* statusImage;


/**
 label that appears (fades) in as the user drags a card & commits to a decline or accept action
 */
@property (nonatomic) UILabel* statusLabel;


@end
