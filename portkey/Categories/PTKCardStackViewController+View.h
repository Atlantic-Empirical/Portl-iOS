//
//  PTKRoomInvitesViewController+View.h
//  portkey
//
//  Created by Robert Reeves on 3/25/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKCardStackViewController.h"
#import "PTKCardView.h"

@interface PTKCardStackViewController (View)


/**
 builds most of the core UI elements for invite controler
 */
- (void)setupView;


/**
 animates cards left, right or up and out of view
 @param BOOL should rotate card during outbound animation
 */
- (void)animateTopCardLeftWithAutoRotation:(BOOL)rotate;
- (void)animateTopCardRightWithAutoRotation:(BOOL)rotate andHideIfEmpty:(BOOL)hideIfEmpty;
- (void)animateTopCardUp;


/**
 load all the room cards UI and complete
 @param NSArray list of PTKRoom's for building the view
 @param loadRoomCompletionBlock optional completion block
 */
- (void)loadCardsWith:(NSArray*)objects withCompletion:(void (^)())loadRoomCompletionBlock;


/**
 update controller view, including buttons & labels
 @param PTKCardView current contents decide UI elements
 */
- (void)updateViewForCard:(PTKCardView*)cardView;


/**
 animates frame position of top/active room card, returning it to its original sitting position
 */
- (void)resetActiveCardViewToOriginFrame;


/**
 returns text for dismiss/decline action on card views, visible as decline button & as text fading over
 the card as you drag & commit to the decline action
 @return NSString for label
 @param PTKCardView with user or room object
 */
- (NSString*)labelTextForDeclineButtonForCardView:(PTKCardView*)cardView;

@end
