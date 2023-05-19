//
//  PTKCardStackViewController.m
//  portkey
//
//  Created by Robert Reeves on 2/4/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKCardStackViewController.h"
#import "PTKRecommendedRoom.h"
#import "PTKAvatarCircles.h"
#import "PTKCardView.h"

#import "PTKCardStackViewController+View.h"


#pragma mark - PTKCardStackViewController

@interface PTKCardStackViewController () <UIGestureRecognizerDelegate> {
    NSInteger _roomPosition;
}

/**
 list of PTKRoom objects for use in room cards
 */
@property (nonatomic) NSMutableArray* listOfObjects;

@property (assign) BOOL hasLoaded;
@property (assign) BOOL shouldAutoEnterRoomOnEntry;


@end


typedef NS_ENUM(NSInteger, PTKDragDirection) {
    PTKDragDirectionLeft,
    PTKDragDirectionRight
};


#define kPTKAcceptDeclineButtonFadeScale 0.005f; // raise for faster fade
#define kPTKAcceptDeclineStampFadeScale 0.01f; // raise for faster fade
#define kPTKAcceptDeclineButtonTransformScale 0.003f
#define kPTKButtonScaleDirectionDown 0.989f
#define kPTKButtonScaleSizeUp 1.011 // raise to speed up the rate accept/decline buttons grow
#define kPTKButtonScaleSizeDown 0.989 // raise to speed up the rate accept/decline buttons shrink
#define kPTKVelocityStrength 500 // required velocity for flicking a room card view towards an accept/decline action
// decrease to make it easier to finger flick an action
#define kPTKGestureDistance 150 // required distance for a finger drag gesture to commit to an accept/decline action


@implementation PTKCardStackViewController


#pragma mark -

- (id)initWithUnderlyingBlurView:(UIView*)view withMasterCardColor:(UIColor*)color withAutoEnterRoomOnEntry:(BOOL)autoEnter {
    
    self = [self init];
    if (!self)
        return nil;
    
    _shouldAutoEnterRoomOnEntry = autoEnter;
    
    self.masterColor = color;
    
    self.blurView = [[PTKBlurView alloc] initWithFrame:self.view.bounds withUnderlyingView:view withBlurRadius:15.0f withBlurType:PTKBlurViewTypeDark];
    [self.view addSubview:self.blurView];
    [self.view sendSubviewToBack:self.blurView];
    
    return self;
}

- (id)init {
    
    self = [super init];
    if (!self)
        return nil;
    
    _hasLoaded = NO;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _roomPosition = 0;
    
    [self setupView];
}


#pragma mark - Pan gesture for finger drag

- (void)panGestureAction:(UIGestureRecognizer *)gestureRecognizer {
    // handle finger pan gesture across screen, accepting / decling room cards based off user action
    
    if (gestureRecognizer != _panGesture) {
        return;
    }
    
    switch (_panGesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            // when gesture begins, store the gesture origin point & the top room's card origin frame
            
            __weak PTKCardView* roomView = _arrayOfCardViews.lastObject;
            
            _originPanGesturePoint = [_panGesture locationInView:self.view];
            _originPanGestureFrame = roomView.frame;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            
            // as pan gesture continues with finger drag, animate the top room card view, tracking finger left or right across the screen
            
            __weak PTKCardView* roomView = _arrayOfCardViews.lastObject;
            
            CGPoint location = [_panGesture locationInView:self.view];
            
            
            // xTravelDistance = gesture distance from origin point
            // ties into single animation block to transform, color/fade & .origin.X changes of buttons & room cards together, for both decline & accept actions
            // up, left & tilt room card.. enlarge & fade background color for decline button, shrink accept button (opposite for accept gesture)
            CGFloat xTravelDistance = location.x - _originPanGesturePoint.x;
            
            CGFloat rotateValue = xTravelDistance/500;
            
            CGFloat buttonSizeScaleSizeAccept = 1.0f + kPTKAcceptDeclineButtonTransformScale * xTravelDistance;
            CGFloat buttonSizeScaleSizeDecline = 1.0f - kPTKAcceptDeclineButtonTransformScale * xTravelDistance;
            
            CGAffineTransform rotation = CGAffineTransformMakeRotation(rotateValue);
            rotation = CGAffineTransformTranslate(rotation, xTravelDistance, -1 * ABS(xTravelDistance));
            
            roomView.transform = rotation;
            
            
            
            // GREEN/RED BUTTON COLOR FADE for accept & decline buttons
            // fade opacity tied to gesture delta
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:0.1 animations:^{
                    
                    _buttonAccept.transform = CGAffineTransformMakeScale(buttonSizeScaleSizeAccept, buttonSizeScaleSizeAccept);
                    _buttonDecline.transform = CGAffineTransformMakeScale(buttonSizeScaleSizeDecline, buttonSizeScaleSizeDecline);
                    
                    CGFloat newAlpha = ABS(xTravelDistance)*kPTKAcceptDeclineButtonFadeScale;
                    if (location.x < _originPanGesturePoint.x) {
                        _buttonDecline.backgroundColor = [[PTKColor redActionColor] colorWithAlphaComponent:newAlpha];
                        _buttonAccept.backgroundColor = [UIColor clearColor];
                        [roomView.statusImage setImage:[PTKGraphics xImageWithColor:[PTKColor almostWhiteColor] backgroundColor:[UIColor clearColor] size:CGSizeMake(22.0f, 22.0f) lineWidth:2.0f]];
                        
                        roomView.statusLabel.text = [self labelTextForDeclineButtonForCardView:roomView];
                    }
                    else {
                        _buttonAccept.backgroundColor = [[PTKColor greenActionColor] colorWithAlphaComponent:newAlpha];
                        _buttonDecline.backgroundColor = [UIColor clearColor];
                        [roomView.statusImage setImage:[UIImage imageNamed:@"check"]];
                        roomView.statusLabel.text = (roomView.room.pending && NILORNULL([[PTKWeakSharingManager roomsDataSource] objectWithId:roomView.room.oid])) ? localizedString(@"ACCEPT") : (roomView.user) ? localizedString(@"ACCEPT") : localizedString(@"JOIN");
                    }
                    
                    roomView.blackOverlayView.alpha = ABS(xTravelDistance)*kPTKAcceptDeclineStampFadeScale;
                }];
            });
            
        }
            break;
        case UIGestureRecognizerStateEnded: {
            
            // when finger gesture ends -- decline, accept or reset the card depending on...
            // velocity: did they flick the card a direction at high speed towards either action?
            // delta: did their finger drag far enough to commit to an action?
            
            CGPoint location = [_panGesture locationInView:self.view];
            CGPoint originMidPoint = CGPointMake(CGRectGetMidX(_originPanGestureFrame), CGRectGetMidY(_originPanGestureFrame));
            CGFloat distance = distance = ABS(location.x - _originPanGesturePoint.x);
            CGPoint velocity = [_panGesture velocityInView:self.view];
            
            if (location.x < originMidPoint.x) {
                // if swiped right
                
                // if the gesture's distance or velocity matched threshold for action, DECLINE room
                if (distance > kPTKGestureDistance || velocity.x < -kPTKVelocityStrength)
                    [self declineRoomWithManualRoomCardRotation:NO];
                else
                    [self resetActiveCardViewToOriginFrame];
            }
            else {
                // else if swiped left
                
                // if the gesture's distance or velocity matched threshold for action, ACCEPT room
                if (distance > kPTKGestureDistance || velocity.x > kPTKVelocityStrength)
                    [self acceptRoomWithManualRoomCardRotation:NO];
                else
                    [self resetActiveCardViewToOriginFrame];
            }
            
            // reset accept / decline buttons to their original transform state
            [UIView animateWithDuration:0.3 animations:^{
                
                _buttonAccept.transform = CGAffineTransformIdentity;
                _buttonDecline.transform = CGAffineTransformIdentity;
            }];
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - room card loading

- (void)completeLoadingRooms {
    
    if (_hasLoaded)
        return;
    
    _hasLoaded = YES;
    
    if (self.listOfObjects.count > 0) {
        
        [self loadCardsWith:self.listOfObjects withCompletion:^{
            
            if ([self.delegate respondsToSelector:@selector(roomInvitesViewControllerNeedsPresentation:)]) {
                [self.delegate roomInvitesViewControllerNeedsPresentation:self];
            }
        }];
    }
}

- (void)presentCardsWithObjects:(NSArray*)objects {
    [self presentCardsWithObjects:objects firstRoom:nil];
}

- (void)presentCardsWithObjects:(NSArray*)objects firstRoom:(NSString *)roomId {
    
    int maxCardCount = (IS_IPHONE5_OR_OLDER) ? 9 : 10; // https://airtime.atlassian.net/browse/KEY-2871
    
    self.listOfObjects = [NSMutableArray arrayWithArray:[objects subarrayWithRange:NSMakeRange(0, MIN(maxCardCount, objects.count))]];
    
    PTKRoom *firstRoom = nil;
    if (!EMPTY_STR(roomId)) {
        for (PTKRoom *room in objects) {
            if ([room isKindOfClass:[PTKRoom class]]) {
                if ([room.oid isEqualToString:roomId]) {
                    firstRoom = room;
                    break;
                }
            }
        }
    }
    
    if (firstRoom && [self.listOfObjects containsObject:firstRoom]) {
        [self.listOfObjects removeObject:firstRoom];
        [self.listOfObjects addObject:firstRoom];
    }
    else if (firstRoom) {
        [self.listOfObjects addObject:firstRoom];
        if (self.listOfObjects.count > 10) {
            [self.listOfObjects removeObjectAtIndex:0];
        }
    }
    
    [self completeLoadingRooms];
}


#pragma mark - button actions

- (void)acceptRoomWithManualRoomCardRotation:(BOOL)rotate {
    _buttonDecline.backgroundColor = [UIColor clearColor];
    _buttonAccept.backgroundColor = [UIColor clearColor];
    
    PTKCardView* roomCard = self.arrayOfCardViews.lastObject;
    BOOL shouldAutoHide = YES;
    
    if (roomCard.room) {
        if ([_delegate respondsToSelector:@selector(roomInvitesViewControllerRoomJoined:)]) {
            [self.delegate roomInvitesViewControllerRoomJoined:roomCard.room.oid];
            shouldAutoHide = NO;
        }
        
        if (roomCard.room.pending) {
            [[PTKWeakSharingManager roomsDataSource] acceptPendingRoom:roomCard.room.oid callback:nil];
            [[PTKWeakSharingManager roomsDataSource] reload];
        } else {
            PTKAPICallback* joinCallback = [[PTKAPICallback alloc] initWithTarget:self selector:@selector(didJoinRoom:) userInfo:@{kKeyRoomId: roomCard.room.oid}];
            [PTKAPI joinRoom:roomCard.room.oid callback:joinCallback];
            
            if ([roomCard.room isRequestToJoin]) {
                [PTKToastManager showToastWithTitle:roomCard.room.roomDisplayName message:localizedString(@"you requested access to join this room") image:nil subImage:nil onTap:nil];
            } else {
                [PTKToastManager showToastWithTitle:roomCard.room.roomDisplayName message:localizedString(@"you entered the room") image:nil subImage:nil onTap:nil];
            }
            
            NSString *action = rotate ? @"buttonTap" : @"swipe";
            [PTKEventTracker track:PTKEventTypeRecommendedRoomJoined withProperties:@{@"roomId":roomCard.room.oid, @"roomPosition":@(_roomPosition), @"action": action}];
        }
    } else {
        if (roomCard.user) {
            [PTKEventTracker track:PTKEventTypeRoomManagerRTJResponse withProperties:@{@"userId": SELF_ID(),
                                                                                       @"roomId": _roomId,
                                                                                       @"requesterUserId": roomCard.user.oid,
                                                                                       @"response": @"accept"}];

            PTKAPICallback* callback = [[PTKAPICallback alloc] initWithTarget:self selector:@selector(didAcceptJoinRequest:) userInfo:roomCard.user];
            [PTKAPI acceptJoinRequestForRoom:_roomId forUser:roomCard.user.userId callback:callback];
        }
    }
    
    
    [self animateTopCardRightWithAutoRotation:rotate andHideIfEmpty:shouldAutoHide];
}

- (void)declineRoomWithManualRoomCardRotation:(BOOL)rotate {
    
    _buttonDecline.backgroundColor = [UIColor clearColor];
    _buttonAccept.backgroundColor = [UIColor clearColor];
    
    
    PTKCardView* roomCard = self.arrayOfCardViews.lastObject;
    
    if (roomCard.room) {
        
        if (roomCard.room.pending) {
            
            [[PTKWeakSharingManager roomsDataSource] dismissPendingRoom:roomCard.room.oid callback:nil];
        }
        else {
            NSString *action = rotate ? @"buttonTap" : @"swipe";
            [PTKEventTracker track:PTKEventTypeRecommendedRoomDenied withProperties:@{@"roomId":roomCard.room.oid, @"roomPosition":@(_roomPosition), @"action": action}];
            [[PTKWeakSharingManager recommendedRoomsDataSource] dismissRecommendedRoom:roomCard.room.oid];
            [[PTKWeakSharingManager recommendedRoomsDataSource] reload];
        }
    }
    else {
        
        if (roomCard.user) {
            [PTKEventTracker track:PTKEventTypeRoomManagerRTJResponse withProperties:@{@"userId": SELF_ID(),
                                                                                       @"roomId": _roomId,
                                                                                       @"requesterUserId": roomCard.user.oid,
                                                                                       @"response": @"reject"}];

            PTKAPICallback* callback = [[PTKAPICallback alloc] initWithTarget:self selector:@selector(didDeclineJoinRequest:) userInfo:roomCard.user];
            [PTKAPI removeMember:roomCard.user.userId fromRoom:_roomId callback:callback];
        }
    }
    
    [self animateTopCardLeftWithAutoRotation:rotate];
}

- (void)didTapDeclineButton {
    [self declineRoomWithManualRoomCardRotation:YES];
}

- (void)didTapAcceptButton {
    [self acceptRoomWithManualRoomCardRotation:YES];
}

- (void)didTapSkipButton {
    PTKCardView* roomCard = self.arrayOfCardViews.lastObject;
    
    if (roomCard.room) {
        // if it's a recommended room only
        if (!roomCard.room.pending) {
            [PTKEventTracker track:PTKEventTypeRecommendedRoomSkipped withProperties:@{@"roomId":roomCard.room.oid, @"roomPosition":@(_roomPosition), @"action": @"buttonTap"}];
        }
    } else if (roomCard.user) {
        [PTKEventTracker track:PTKEventTypeRoomManagerRTJResponse withProperties:@{@"userId": SELF_ID(),
                                                                                   @"roomId": _roomId,
                                                                                   @"requesterUserId": roomCard.user.oid,
                                                                                   @"response": @"ignore"}];

    }

    [self animateTopCardUp];
}

- (void)didTapCancelButton {
    PTKCardView* roomCard = self.arrayOfCardViews.lastObject;
    if (roomCard.room) {
        
        // if it's a recommended room only
        if (!roomCard.room.pending) {
            [PTKEventTracker track:PTKEventTypeRecommendedRoomDismissed withProperties:@{@"roomId":roomCard.room.oid, @"roomPosition":@(_roomPosition)}];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(roomInvitesViewControllerNeedsDismissal:)]) {
        [self.delegate roomInvitesViewControllerNeedsDismissal:self];
    }
}


#pragma mark -

- (void)didAcceptJoinRequest:(PTKAPIResponse*)response {
    
    PTKUser* user = (PTKUser*)response.userInfo;
    [PTKToastManager showToastFromUser:user title:user.firstName roomId:@"" message:localizedString(@"was granted access by you") subImage:nil withinView:nil forToastType:0 onTap:nil];
}

- (void)didDeclineJoinRequest:(PTKAPIResponse*)response {
    
    PTKUser* user = (PTKUser*)response.userInfo;
    [PTKToastManager showToastFromUser:user title:user.firstName roomId:@"" message:localizedString(@"was denied access by you") subImage:nil withinView:nil forToastType:0 onTap:nil];
}

- (void)didJoinRoom:(PTKAPIResponse*)response {
    
    if (response.error) {
        PTKLogError(@"Join room error: %@", response.error.localizedDescription);
        
        if ([response.error isError:PTKErrorCodeInvitationRequired]) {
            PTKAlertController* alert = [PTKAlertController alertControllerWithTitle:localizedString(@"Invitation Needed") message:localizedString(@"Sorry, you can't join this room without an invitation.") preferredStyle:UIAlertControllerStyleAlert];
            [alert addCancelButtonWithTitle:localizedString(@"OK") block:nil];
            
            if (self.beingDismissed) {
                [self.presentingViewController presentViewController:alert animated:YES completion:nil];
            }
            else {
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        else {
            PTKAlertController* alert = [PTKAlertController alertControllerWithTitle:localizedString(@"Something Went Wrong") message:localizedString(@"please try again") preferredStyle:UIAlertControllerStyleAlert];
            [alert addCancelButtonWithTitle:localizedString(@"OK") block:nil];
            
            if (self.beingDismissed) {
                [self.presentingViewController presentViewController:alert animated:YES completion:nil];
            }
            else {
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    else {
        
        NSString* roomId = response.userInfo[kKeyRoomId];
        if (EMPTY_STR(roomId))
            return;
        
        
        [[PTKWeakSharingManager recommendedRoomsDataSource] removeObjectWithId:roomId completion:nil];
        
        if (!_shouldAutoEnterRoomOnEntry)
            return;
        
        
        NSDictionary* responseDict = response.JSON;
        if ([responseDict isKindOfClass:[NSDictionary class]]) {
            NSString* state = responseDict[@"state"];

            if ([state isEqualToString:@"requested"]) {
                [PTKEventTracker track:PTKEventTypeRoomManagerRTJRequest withProperties:@{@"userId": SELF_ID(), @"roomId": roomId}];
            } else if ([state isEqualToString:@"active"]) {
                [self.roomNavigationController enterRoom:roomId withMessage:nil source:PTKRoomSourceTypeJoined animated:YES completion:nil];
            }
        }
    }
}

#pragma mark -

- (void)removeTopCardObject {
    
    _roomPosition = _roomPosition + 1;
    
    [_arrayOfCardViews removeObject:_arrayOfCardViews.lastObject];
    [_listOfObjects removeLastObject];
    
    [self updateViewForCard:_arrayOfCardViews.lastObject];
}

- (void)closeControllerIfEmptyCardStack {
    if (_arrayOfCardViews.count == 0) {
        [self didTapCancelButton];
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
