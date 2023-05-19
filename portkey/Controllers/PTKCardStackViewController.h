//
//  PTKCardStackViewController.h
//  portkey
//
//  Created by Robert Reeves on 2/4/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKBlurView.h"

typedef NS_ENUM(NSInteger, PTKRoomCardStyle) {
    PTKRoomCardStyleReccomended,
    PTKRoomCardStylePending,
    PTKRoomCardStyleRequestJoin
};

@class PTKCardStackViewController;

@protocol PTKCardStackViewControllerDelegate <NSObject>

/**
 PTKRoomInvitesViewController will notify delegate it's ready to present or dismiss
 once cards have been processed or emptied
 */
- (void)roomInvitesViewControllerNeedsPresentation:(PTKCardStackViewController *)recommendedRoomViewController;
- (void)roomInvitesViewControllerNeedsDismissal:(PTKCardStackViewController *)recommendedRoomViewController;

@optional
- (void)roomInvitesViewControllerRoomJoined:(NSString *)roomId;

@end



@interface PTKCardStackViewController : UIViewController

@property (weak, readwrite) id<PTKCardStackViewControllerDelegate> delegate;


/**
 roomId & masterColor used to override background colors for all cards in stack
 */
@property (nonatomic) NSString* roomId;
@property (nonatomic) UIColor* masterColor;


/**
 UIView container for positioning room cards as a unified stack
 */
@property (nonatomic) UIView* viewContainerAllCards;


/**
 cache of presented room cards, used to interact/dismiss/position during gesture recgonizer & button CTA's
 */
@property (nonatomic) NSMutableArray* arrayOfCardViews;


/**
 visual effect background blurring content behind PTKRoomInvitesViewController
 */
@property (nonatomic) PTKBlurView* blurView;


/**
 buttons to accept, decline or skip cards, or dismiss PTKRoomInvitesViewController
 */
@property (nonatomic) UIButton* buttonCancel;
@property (nonatomic) UIButton* buttonAccept;
@property (nonatomic) UIButton* buttonDecline;
@property (nonatomic) UIButton* buttonSkip;

/**
 labels for buttons
 */
@property (nonatomic) UILabel* labelAccept;
@property (nonatomic) UILabel* labelDecline;
@property (nonatomic) UILabel* labelSkip;

/**
 label floating at top of controller to optionally give extra instructions
 */
@property (nonatomic) UILabel* labelInstructions;


/**
 gesture recognizer & properties allow touch->drag tinder like card animations
 */
@property (nonatomic) UIPanGestureRecognizer* panGesture;
@property (nonatomic) CGPoint originPanGesturePoint;
@property (nonatomic) CGRect originPanGestureFrame;



/**
 init PTKRoomInvitesViewController
 @param UIView view to be blurred as a background blur view
 @param UIColor optional master color to override background colors for all cards in the stack
 @param BOOL optional (default NO) will or won't automatically enter a room immediately on room entry
 */
- (id)initWithUnderlyingBlurView:(UIView*)view withMasterCardColor:(UIColor*)color withAutoEnterRoomOnEntry:(BOOL)autoEnter;


/**
 removes the top/active room from the datasource
 */
- (void)removeTopCardObject;

 
/**
 dismisses the controller if listOfRooms is empty
 */
- (void)closeControllerIfEmptyCardStack; 


/**
 loads entire controller view and pushes onto stack when complete
 @param NSArray list of PTKRoom objects to build cards for
 @param NSString optional room.oid for the PTKRoom you want to appear on the top of the stack
 */
- (void)presentCardsWithObjects:(NSArray*)objects;
- (void)presentCardsWithObjects:(NSArray*)objects firstRoom:(NSString *)roomId;


/**
 gestures and actions for leaving, skipping, accepting or declining
 */
- (void)panGestureAction:(UIPanGestureRecognizer *)pan;
- (void)didTapCancelButton;
- (void)didTapSkipButton;
- (void)didTapAcceptButton;
- (void)didTapDeclineButton;


@end
