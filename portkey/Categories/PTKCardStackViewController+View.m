//
//  PTKRoomInvitesViewController+View.m
//  portkey
//
//  Created by Robert Reeves on 3/25/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKCardStackViewController+View.h"
#import "PTKRecommendedRoom.h"
#import "PTKCardView.h"
#import "PTKAvatarCircles.h"

@interface PTKCardStackViewController () <UIGestureRecognizerDelegate>

@end

@implementation PTKCardStackViewController (View)


#pragma mark - view setup

- (void)setupView {
    // pan gesture for moving room cards with finger track
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    self.panGesture.cancelsTouchesInView = NO;
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
    
    
    // cancel dismiss button
    self.buttonCancel = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width*0.73f, 20.0f, 100.0f, 44.0f)];
    [self.buttonCancel setImage:[PTKGraphics xImageWithColor:[PTKColor almostWhiteColor] backgroundColor:[UIColor clearColor] size:CGSizeMake(15.0f, 15.0f) lineWidth:1.5f] forState:UIControlStateNormal];
    self.buttonCancel.imageView.contentMode = UIViewContentModeCenter;
    self.buttonCancel.titleLabel.font = [PTKFont regularFontOfSize:17.0f];
    [self.buttonCancel addTarget:self action:@selector(didTapCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonCancel];
    
    
    // skip button
    self.buttonSkip = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x-22.0f, self.view.height-160.0f, 44.0f, 44.0f)];
    self.buttonSkip.clipsToBounds = YES;
    self.buttonSkip.layer.cornerRadius = self.buttonSkip.height/2;
    [self.buttonSkip setImage:[UIImage imageNamed:@"btn-skip"] forState:UIControlStateNormal];
    [self.buttonSkip setBackgroundImage:[PTKGraphics imageWithColor:[PTKColor grayColor]] forState:UIControlStateHighlighted];
    [self.buttonSkip addTarget:self action:@selector(didTapSkipButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.buttonSkip];
    
    self.labelSkip = [[UILabel alloc] initWithFrame:CGRectMake(self.buttonSkip.frame.origin.x, CGRectGetMaxY(self.buttonSkip.frame), self.buttonSkip.width, 33.0f)];
    self.labelSkip.text = localizedString(@"SKIP");
    self.labelSkip.textAlignment = NSTextAlignmentCenter;
    self.labelSkip.textColor = [PTKColor almostWhiteColor];
    [self.view addSubview:self.labelSkip];
    
    
    // decline button
    self.buttonDecline = [[UIButton alloc] initWithFrame:CGRectMake(self.buttonSkip.frame.origin.x-self.buttonSkip.width-50.0f, self.buttonSkip.frame.origin.y, self.buttonSkip.width, self.buttonSkip.height)];
    self.buttonDecline.clipsToBounds = YES;
    self.buttonDecline.layer.cornerRadius = self.buttonDecline.height/2;
    [self.buttonDecline setImage:[UIImage imageNamed:@"btn-decline"] forState:UIControlStateNormal];
    [self.buttonDecline addTarget:self action:@selector(didTapDeclineButton) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonDecline setBackgroundImage:[PTKGraphics imageWithColor:[PTKColor redActionColor]] forState:UIControlStateHighlighted];
    [self.view addSubview:self.buttonDecline];
    
    self.labelDecline = [[UILabel alloc] initWithFrame:CGRectMake(self.buttonDecline.frame.origin.x, CGRectGetMaxY(self.buttonDecline.frame), self.buttonDecline.width, 33.0f)];
    self.labelDecline.text = localizedString(@"DECLINE");
    self.labelDecline.adjustsFontSizeToFitWidth = YES;
    self.labelDecline.textAlignment = NSTextAlignmentCenter;
    self.labelDecline.textColor = [PTKColor almostWhiteColor];
    [self.view addSubview:self.labelDecline];
    
    
    // accept button
    self.buttonAccept = [[UIButton alloc] initWithFrame:CGRectMake(self.buttonSkip.frame.origin.x+self.buttonSkip.width+50.0f, self.buttonSkip.frame.origin.y, self.buttonSkip.width, self.buttonSkip.height)];
    self.buttonAccept.clipsToBounds = YES;
    self.buttonAccept.layer.cornerRadius = self.buttonAccept.height/2;
    [self.buttonAccept setImage:[UIImage imageNamed:@"btn-accept"] forState:UIControlStateNormal];
    [self.buttonAccept addTarget:self action:@selector(didTapAcceptButton) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonAccept setBackgroundImage:[PTKGraphics imageWithColor:[PTKColor greenActionColor]] forState:UIControlStateHighlighted];
    self.buttonAccept.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:self.buttonAccept];
    
    self.labelAccept = [[UILabel alloc] initWithFrame:CGRectMake(self.buttonAccept.frame.origin.x-12.0f, CGRectGetMaxY(self.buttonAccept.frame), 70.0f, 33.0f)];
    self.labelAccept.text = localizedString(@"JOIN ROOM");
    self.labelAccept.textAlignment = NSTextAlignmentCenter;
    self.labelAccept.textColor = [PTKColor almostWhiteColor];
    [self.view addSubview:self.labelAccept];
    
    
    self.labelDecline.font = [PTKFont regularFontOfSize:10.0f];
    self.labelSkip.font = self.labelDecline.font;
    self.labelAccept.font = self.labelDecline.font;
    
    
    // floating instruction label
    self.labelInstructions = [[UILabel alloc] initWithFrame:CGRectMake(0, 75.0f, self.view.width, 55.0f)];
    self.labelInstructions.text = localizedString(@"This room requires\npermission to join");
    self.labelInstructions.font = [PTKFont regularFontOfSize:17.0f];
    self.labelInstructions.numberOfLines = 2;
    self.labelInstructions.textAlignment = NSTextAlignmentCenter;
    self.labelInstructions.textColor = [UIColor lightTextColor];
    self.labelInstructions.hidden = YES;
    [self.view addSubview:self.labelInstructions];
}

- (void)loadCardsWith:(NSArray*)objects withCompletion:(void (^)())loadRoomCompletionBlock {
    
    // store room card views for frame manipulation during finger drag & accept/decline actions
    self.arrayOfCardViews = [NSMutableArray arrayWithCapacity:objects.count];
    
    
    self.viewContainerAllCards = [[UIView alloc] init];
    self.viewContainerAllCards.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.viewContainerAllCards];
    
    
    int idx = 0; // staggers Y axis for each room card, to form a stack
    for (id cardObject in objects) {
        
        CGSize cardSize = CGSizeMake(self.view.width * 0.7f, self.view.width * 0.7f);
        CGFloat bufferBetweenCardsInStack = objects.count*10.0f;
        CGRect frameForParentView = CGRectMake(0, -(idx * 10.0f) + bufferBetweenCardsInStack, cardSize.width, cardSize.height);
        PTKCardView* parentView = [[PTKCardView alloc] initWithFrame:frameForParentView withMasterCardColor:self.masterColor];
        [parentView updateViewWithObject:cardObject];
        [self updateViewForCard:parentView];
        
        idx++; // stagger each card view
        
        [self.viewContainerAllCards addSubview:parentView];
        [self.arrayOfCardViews addObject:parentView]; // for frame animations during accept/decline actions
    }
    
    [self setupViewButtonsWith:idx];
    
    if (loadRoomCompletionBlock)
        loadRoomCompletionBlock();
}

- (void)setupViewButtonsWith:(int)cards {
    
    CGSize roomSize = CGSizeMake(self.view.width * 0.7f, self.view.width * 0.7f);
    CGFloat containerHeight = roomSize.height+(cards*10.0f);
    self.viewContainerAllCards.frame = CGRectMake(self.view.center.x-(roomSize.width/2), (self.view.bounds.size.height/2)-(containerHeight/2)-15.0f, roomSize.width, containerHeight);
    
    self.buttonDecline.frame = CGRectMake(self.buttonDecline.frame.origin.x, CGRectGetMaxY(self.viewContainerAllCards.frame)+30.0f, self.buttonDecline.bounds.size.width, self.buttonDecline.bounds.size.height);
    self.buttonAccept.frame = CGRectMake(self.buttonAccept.frame.origin.x, CGRectGetMaxY(self.viewContainerAllCards.frame)+30.0f, self.buttonAccept.bounds.size.width, self.buttonAccept.bounds.size.height);
    self.buttonSkip.frame = CGRectMake(self.buttonSkip.frame.origin.x, CGRectGetMaxY(self.viewContainerAllCards.frame)+30.0f, self.buttonSkip.bounds.size.width, self.buttonSkip.bounds.size.height);
    self.labelDecline.frame = CGRectMake(self.labelDecline.frame.origin.x, CGRectGetMaxY(self.buttonDecline.frame), self.labelDecline.bounds.size.width, self.labelDecline.bounds.size.height);
    self.labelAccept.frame = CGRectMake(self.labelAccept.frame.origin.x, self.labelDecline.frame.origin.y, self.labelAccept.bounds.size.width, self.labelDecline.bounds.size.height);
    self.labelSkip.frame = CGRectMake(self.labelSkip.frame.origin.x, self.labelDecline.frame.origin.y, self.labelSkip.bounds.size.width, self.labelDecline.bounds.size.height);
}

- (void)updateViewForCard:(PTKCardView*)cardView {
    
    BOOL foundInPending = false;
    for (PTKRoom *pendingRoom in [PTKWeakSharingManager roomsDataSource].pendingRooms) {
        if ([pendingRoom.oid isEqualToString:cardView.room.oid]) {
            foundInPending = true;
            break;
        }
    }
    
    self.labelDecline.text = [self labelTextForDeclineButtonForCardView:cardView];
    
    if ([cardView.room isRequestToJoin] && !cardView.room.pending && !foundInPending && NILORNULL([[PTKWeakSharingManager roomsDataSource] objectWithId:cardView.room.oid])) {
        
        
        self.labelAccept.text = localizedString(@"REQUEST ACCESS");
        self.labelInstructions.hidden = NO;
        
        CGPoint center = self.labelAccept.center;
        [self.labelAccept sizeToFit];
        self.labelAccept.center = center;
    }
    else if (cardView.room) {
        
        if (cardView.room.pending) {
            
            self.labelAccept.text = localizedString(@"ACCEPT");
        }
        else {
            
            self.labelAccept.text = localizedString(@"JOIN ROOM");
        }
        
        self.labelInstructions.hidden = YES;
    }
    else if (cardView.user) {
        
        self.labelInstructions.hidden = YES;
        self.labelAccept.text = localizedString(@"ACCEPT");
    }
    else if (NILORNULL(cardView.room) && NILORNULL(cardView.user)) {
        
        self.labelAccept.hidden = YES;
        self.labelDecline.hidden = YES;
        self.labelSkip.hidden = YES;
        self.buttonSkip.hidden = YES;
        self.buttonAccept.hidden = YES;
        self.buttonDecline.hidden = YES;
        self.labelInstructions.hidden = YES;
    }
}


#pragma mark - animate room cards

- (void)animateTopCardUp {
    // rotate/move room card up in UI, remove room view from top of room card stack
    
    self.buttonDecline.backgroundColor = [UIColor clearColor];
    self.buttonAccept.backgroundColor = [UIColor clearColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PTKCardView* roomView = self.arrayOfCardViews.lastObject;
        [self removeTopCardObject];
        
        __weak __typeof__(self) weakSelf = self;
        [UIView animateWithDuration:0.4 animations:^{
            
            roomView.frame = CGRectMake(roomView.frame.origin.x, -self.view.bounds.size.height, roomView.width, roomView.height);
            
        } completion:^(BOOL finished) {
            __strong __typeof__(self) strongSelf = weakSelf;
            
            [strongSelf closeControllerIfEmptyCardStack];
        }];
    });
}

- (void)animateTopCardRightWithAutoRotation:(BOOL)rotate andHideIfEmpty:(BOOL)hideIfEmpty {
    // rotate/move room card up in UI, remove room view from top of room card stack
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PTKCardView* roomView = self.arrayOfCardViews.lastObject;
        [self removeTopCardObject];
        
        [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            roomView.frame = CGRectOffset(roomView.frame, 700.0f, -1000.0f);
            
            if (rotate)
                roomView.transform = CGAffineTransformMakeRotation((CGFloat)M_PI / 2.0f);
            
        } completion:nil];
        
        if (hideIfEmpty) [self closeControllerIfEmptyCardStack];
    });
}

- (void)animateTopCardLeftWithAutoRotation:(BOOL)rotate {
    // rotate/move room card up in UI, remove room view from top of room card stack
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PTKCardView* roomView = self.arrayOfCardViews.lastObject;
        [self removeTopCardObject];
        
        [UIView animateWithDuration:0.7 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            roomView.frame = CGRectOffset(roomView.frame, -700.0f, -1000.0f);
            
            if (rotate)
                roomView.transform = CGAffineTransformMakeRotation(-(CGFloat)M_PI / 2.0f);
            
        } completion:nil];
        
        [self closeControllerIfEmptyCardStack];
    });
}

- (void)resetActiveCardViewToOriginFrame {
    // moves the active room card back to its origin location in view, after user releases finger gesture and has not committed to a decline/accept action
    
    // resets button background fade colors
    self.buttonDecline.backgroundColor = [UIColor clearColor];
    self.buttonAccept.backgroundColor = [UIColor clearColor];
    
    // return room card to its original positino in the UI stack
    [UIView animateWithDuration:0.3 animations:^{
        PTKCardView* roomView = self.arrayOfCardViews.lastObject;
        roomView.blackOverlayView.alpha = 0;
        
        roomView.transform = CGAffineTransformIdentity;
        
        roomView.frame = self.originPanGestureFrame;
    }];
}


#pragma mark - 

- (NSString*)labelTextForDeclineButtonForCardView:(PTKCardView*)cardView {
    
    BOOL roomIsPending = NO;
    if (!NILORNULL(cardView.room)) {
        roomIsPending = (cardView.room.pending && NILORNULL([[PTKWeakSharingManager roomsDataSource] objectWithId:cardView.room.oid]));
    }
    BOOL userIsRequestingAccess = NO;
    if (!NILORNULL(cardView.user)) {
        userIsRequestingAccess = YES;
    }
    
    if (roomIsPending || userIsRequestingAccess)
        return localizedString(@"DECLINE");
    else
        return localizedString(@"DISMISS");
}

@end
