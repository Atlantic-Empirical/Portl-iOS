

//
//  PTKRoomViewController+RoomHints.m
//  portkey
//
//  Created by Robert Reeves on 5/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKRoomViewController+RoomHints.h"
#import "PTKPermissionManager.h"
#import "PTKRoomPresence.h"
#import "PTKTriangleView.h"
#import "PTKHintMessagePropertyCell.h"

@implementation PTKRoomViewController (RoomHints)


#pragma mark - hint education

- (void)launchHintView:(PTKHintType)hintType relatedUserId:(NSString *)userId {
    if ([self shouldIgnoreHintLaunchRequest:hintType]) {
        return;
    }
    
    self.actionButtonsView.pasteButton.hidden = YES;
    
    self.hintViewOnScreen = YES;
    
    self.selectedHintType = hintType;
    
    self.hintView = [[PTKHintView alloc] initWithFrame:self.view.bounds];
    self.hintView.alpha = 0;
    self.hintView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    self.hintView.userInteractionEnabled = YES;
    self.hintView.exclusiveTouch = NO;
    [self.hintView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nudgeOmniButton)]];

    CGRect bounds = self.hintView.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    CGFloat radius = 100;
    CGRect circleRect = CGRectZero;
    UIBezierPath *path;
    UIButton* hintHolePunchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    switch (hintType) {
        case PTKHintTypeLiveCameraPresenceAndVideoSwitch:
            if (!userId) return;
            
            circleRect = [self.roomHeader frameForStreamViewWithUserId:userId];
            self.hintRect = circleRect;
            path = [UIBezierPath bezierPathWithOvalInRect:circleRect];
            
            [self enableDismissOverlayTap];
            
            [self.view addSubview:self.hintView];
            [self.roomHeader setTitleHidden:YES];
            [self.roomHeader setRoomPresenceFrozen:YES];

            break;
        case PTKHintTypeSignalButton:
            
            
            circleRect = [self.view convertRect:self.roomHeader.stickyLiveCameraButton.frame fromView:self.roomHeader.stickyLiveCameraButton.superview];
            self.hintRect = circleRect;
            path = [UIBezierPath bezierPathWithOvalInRect:circleRect];

        {
            NSInteger frameCount = 324;
            UIImageView *animationView = [[UIImageView alloc] init];
            animationView.contentMode = UIViewContentModeScaleAspectFit;
            animationView.frame = CGRectMake(0, 0, 250, 250);
            animationView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(animationView.frame) + CGRectGetMidY(self.hintRect) - 60);
            NSMutableArray *frames = [[NSMutableArray alloc] initWithCapacity:frameCount];
            for (int i = 1 ; i <= frameCount ; i++) {
                NSString *frameName = [NSString stringWithFormat:@"%@-%d", @"signal-hint", i];
                NSURL *frameURL = [[NSBundle mainBundle] URLForResource:frameName withExtension:@"png"];
                [frames addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:frameURL]]];
            }
            animationView.animationImages = frames;
            animationView.animationDuration = frameCount/30.0f;
            animationView.animationRepeatCount = NSIntegerMax;


            [self.hintView addSubview:animationView];
            [animationView startAnimating];
        }

//            self.hintView.userInteractionEnabled = NO;
            [self enableDismissOverlayTap];

            [self.view addSubview:self.hintView];
            break;

        case PTKHintTypePlayAll:
            circleRect = CGRectMake(CGRectGetMidX(bounds) - radius, CGRectGetMidY(bounds), 0, 0);
            self.hintRect = circleRect;
            
            path = [UIBezierPath bezierPathWithOvalInRect:circleRect];
            
            [self enableDismissOverlayTap];
            
            [self.view addSubview:self.hintView];
            break;
        case PTKHintTypePresence: {
            if (!userId) return;
            
            circleRect = [self.roomHeader frameForStreamViewWithUserId:userId];
            self.hintRect = circleRect;

            [self enableDismissOverlayTap];
            
            path = [UIBezierPath bezierPathWithOvalInRect:circleRect];
            
            [self.view addSubview:self.hintView];
            [self.roomHeader setRoomPresenceFrozen:YES];
        }
            break;
        case PTKHintTypeVideoSwitch:
            circleRect = [self.view convertRect:self.roomHeader.stickyLiveCameraButton.frame fromView:self.roomHeader.stickyLiveCameraButton.superview];
            self.hintRect = circleRect;
            
            path = [UIBezierPath bezierPathWithRoundedRect:circleRect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(circleRect.size.height/2, circleRect.size.height/2)];
            
            hintHolePunchButton.frame = circleRect;
            [hintHolePunchButton addTarget:self action:@selector(toggleCameraOn) forControlEvents:UIControlEventTouchUpInside];
            [self.hintView addSubview:hintHolePunchButton];
            
            [self enableDismissOverlayTap];
            
            [self.view addSubview:self.hintView];
            
            [PTKEventTracker track:PTKEventTypeUserEducationInterstitialLoaded withProperties:@{@"type":@"cameraSwitch"}];
            
            break;
        case PTKHintTypeOmniButton:
            path = [UIBezierPath bezierPathWithRect:CGRectMake(0, self.hintView.height - 44.0f, self.hintView.width, 44.0f)];
            
            [self.view insertSubview:self.hintView belowSubview:self.actionButtonsView];
            
            [PTKEventTracker track:PTKEventTypeUserEducationInterstitialLoaded withProperties:@{@"type":@"mediaTray"}];
            
            break;
        default:
            break;
    }
    
    [self showHintBubble:hintType relatedUserId:userId];
    [self registerHintTypeAsShown:hintType];
    
    // draw hole punch mask
    self.hintView.cutoutPath = [path copy];
    [path appendPath:[UIBezierPath bezierPathWithRect:bounds]];
    maskLayer.path = path.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    self.hintView.layer.mask = maskLayer;
    
    
    // animate completed view in
    [UIView animateWithDuration:0.4 animations:^{
        self.hintView.alpha = 1;
    }];
}

- (void)enableDismissOverlayTap {
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hintViewTapped)];
    [self.hintView addGestureRecognizer:tap];
}


- (void)hintViewTapped {
    if (self.selectedHintType == PTKHintTypeVideoSwitch) {
        [PTKEventTracker track:PTKEventTypeUserEducationInterstitialClosed withProperties:@{@"type":@"cameraSwitch", @"actionSource":@"other"}];
    }
    
    [self transitionHintViewToNextStep];
}


#pragma mark -

- (void)transitionHintViewToNextStep {
    switch (self.selectedHintType) {
        case PTKHintTypeOmniButton: {
            [self dismissHintViewWithCompletion:^{
                [self launchHintView:PTKHintTypeVideoSwitch relatedUserId:nil];
            }];
        }
            break;
        case PTKHintTypePresence: {
            [self dismissHintViewWithCompletion:^{
                [self launchHintView:PTKHintTypeVideoSwitch relatedUserId:nil];
            }];
        }
            break;
        case PTKHintTypeVideoSwitch: {
            [self presenceTick];
            [self dismissHintViewWithCompletion:^{
                [self maybeShowNotificationPermission];
            }];
        }
            break;
        case PTKHintTypeLiveCameraPresenceAndVideoSwitch: {
            
            [self.roomHeader setTitleHidden:NO];
            
            [self dismissHintViewWithCompletion:^{
                [self launchHintView:PTKHintTypeVideoSwitch relatedUserId:nil];
            }];
        }
            break;
        default: {
            [self dismissHintViewWithCompletion:^{
                [self maybeShowNotificationPermission];
            }];
        }
            break;
    }
}

- (void)showHintBubble:(PTKHintType)hintType relatedUserId:(NSString *)userId {
    PTKRoomPresence* roomP = nil;
    
    PTKRoom* room = [[PTKWeakSharingManager roomsDataSource] objectWithId:self.roomId];
    
    if (userId) {
        roomP = [self.allMembersDataSource presenceWithId:userId];
    }
    
    if (!roomP && self.allMembersDataSource.activePresences.count > 0) {
        roomP = self.allMembersDataSource.activePresences.firstObject;
        
        if ([roomP.member.user.userId isEqualToString:SELF_ID()]) {
            roomP = self.allMembersDataSource.activePresences.lastObject;
        }
    }
    
    UIView* bubbleView = [[UIView alloc] initWithFrame:CGRectZero];
    bubbleView.backgroundColor = self.view.tintColor;
    bubbleView.layer.cornerRadius = 3.0;
    bubbleView.clipsToBounds = YES;
    [self.hintView addSubview:bubbleView];
    
    UILabel* hintLabelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    hintLabelTitle.textAlignment = NSTextAlignmentCenter;
    hintLabelTitle.adjustsFontSizeToFitWidth = YES;
    hintLabelTitle.minimumScaleFactor = 0.5f;
    hintLabelTitle.textColor = [PTKColor almostWhiteColor];
    [bubbleView addSubview:hintLabelTitle];
    
    UILabel* hintLabelDescription = [[UILabel alloc] initWithFrame:CGRectZero];
    hintLabelDescription.textAlignment = NSTextAlignmentCenter;
    hintLabelDescription.numberOfLines = 3;
    hintLabelDescription.adjustsFontSizeToFitWidth = YES;
    hintLabelDescription.textColor = [PTKColor almostWhiteColor];
    hintLabelDescription.font = [PTKFont regularFontOfSize:15];
    [bubbleView addSubview:hintLabelDescription];
     
    
    switch (hintType) {
        case PTKHintTypeLiveCameraPresenceAndVideoSwitch:
            bubbleView.frame = CGRectMake(20.0f, CGRectGetMaxY(self.hintRect)+15.0f, self.view.width-40.0f, 120.0f);
            hintLabelTitle.frame = CGRectMake(0, 10.0f, bubbleView.width, 22.0f);
            hintLabelDescription.frame = CGRectMake(20.0f, CGRectGetMaxY(hintLabelTitle.frame), bubbleView.width-40.0f, 80.0f);
            if (roomP) {
                if (roomP.member.user.firstName.length > 0)
                    hintLabelTitle.text = [NSString stringWithFormat:NSLocalizedString(@"%@'s camera is on!", 0), roomP.member.user.firstName];
                else
                    hintLabelTitle.text = NSLocalizedString(@"Someone's camera is on!", 0);
            }
            hintLabelDescription.text = NSLocalizedString(@"Tap the camera button to get together right now - super simple video chat with up to six people.", 0);
            break;
        case PTKHintTypeSignalButton: {
            bubbleView.frame = CGRectMake(20, CGRectGetMaxY(self.view.bounds)-120.0f-15.0f, self.view.width-40.0f, 120.0f);
            hintLabelTitle.frame = CGRectMake(0, 10.0f, bubbleView.width, 22.0f);
            hintLabelDescription.frame = CGRectMake(20.0f, CGRectGetMaxY(hintLabelTitle.frame), bubbleView.width-40.0f, 80.0f);
            hintLabelTitle.text = NSLocalizedString(@"Gather People Together", 0);
            hintLabelDescription.text = NSLocalizedString(@"Pull and release your photo to send a signal to everyone telling them that you're here and want to hang out. Don't be shy - give it a try!", 0);

            if (room.roomColor.isBright && self.currentRoomUIMode == PTKRoomUIModeNormal) {
                hintLabelTitle.textColor = [PTKColor almostBlackColor];
                hintLabelDescription.textColor = [PTKColor almostBlackColor];
            }
            else {
                hintLabelTitle.textColor = [PTKColor almostWhiteColor];
                hintLabelDescription.textColor = [PTKColor almostWhiteColor];
            }

            break;
        }
        case PTKHintTypePlayAll: {
            
            bubbleView.frame = CGRectMake(20.0f, CGRectGetMinY(self.hintRect)+20.0f, self.view.width-40.0f, 120.0f);
            hintLabelTitle.frame = CGRectMake(10.0f, 10.0f, bubbleView.width-20.0f, 22.0f);
            hintLabelDescription.frame = CGRectMake(20.0f, CGRectGetMaxY(hintLabelTitle.frame), bubbleView.width-40.0f, 80.0f);
            hintLabelTitle.text = [NSString stringWithFormat:NSLocalizedString(@"%@ Just Presented for Everyone!", 0), (NILORNULL(room.presentingUser) || [room.presentingUser.oid isEqualToString:SELF_ID()]) ? @"You" : room.presentingUser.firstName];
            hintLabelDescription.text = NSLocalizedString(@"The room is now enjoying this together in real time. Try going LIVE to chat!", 0);
            
            if (room.roomColor.isBright) {
                hintLabelTitle.textColor = [PTKColor grayColor];
                hintLabelDescription.textColor = [PTKColor grayColor];
            }
            else {
                hintLabelTitle.textColor = [PTKColor almostWhiteColor];
                hintLabelDescription.textColor = [PTKColor almostWhiteColor];
            }

            break;
        }
        case PTKHintTypePresence: {
            bubbleView.frame = CGRectMake(40.0f, CGRectGetMaxY(self.hintRect)+22.0f, self.view.width-80.0f, 150.0f);
            hintLabelTitle.frame = CGRectMake(0, 10.0f, bubbleView.width, 22.0f);
            hintLabelDescription.frame = CGRectMake(20.0f, CGRectGetMaxY(hintLabelTitle.frame), bubbleView.width-40.0f, 80.0f);
            
            if (roomP) {
                if (roomP.member.user.firstName.length > 0)
                    hintLabelTitle.text = [NSString stringWithFormat:NSLocalizedString(@"%@ is Here!", 0), roomP.member.user.firstName];
                else
                    hintLabelTitle.text = NSLocalizedString(@"A Friend is Here!", 0);
            }
            hintLabelDescription.text = NSLocalizedString(@"When their picture lights up - it means that they are here in the room with you - right now!", 0);

            UIView* sepView = [[UIView alloc] initWithFrame:CGRectMake(0, bubbleView.height-32-10, bubbleView.width, 1)];
            sepView.backgroundColor = [PTKColor almostWhiteColor];
            sepView.alpha = 0.5;
            [bubbleView addSubview:sepView];

            UILabel* gotItLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, bubbleView.height-22-10, bubbleView.width, 22)];
            gotItLabelTitle.textAlignment = NSTextAlignmentCenter;
            gotItLabelTitle.textColor = [PTKColor almostWhiteColor];
            gotItLabelTitle.font = [PTKFont boldFontOfSize:16];
            gotItLabelTitle.text = NSLocalizedString(@"GOT IT!", 0);
            [bubbleView addSubview:gotItLabelTitle];

            PTKRoom *room = [[PTKWeakSharingManager roomsDataSource] objectWithId:self.roomId];
            if (room.roomColor.isBright) {
                hintLabelTitle.textColor = [UIColor blackColor];
                hintLabelDescription.textColor = [UIColor blackColor];
                sepView.backgroundColor = [UIColor blackColor];
                gotItLabelTitle.textColor = [UIColor blackColor];
            }

            break;
        }
        case PTKHintTypeVideoSwitch: {
            bubbleView.frame = CGRectMake(40, CGRectGetMaxY(self.hintRect)+25.0f, self.view.width-80.0f, 120.0f);
            hintLabelTitle.font = [PTKFont regularFontOfSize:14.0f];
            hintLabelTitle.numberOfLines = 2;
            bubbleView.backgroundColor = [PTKColor darkGrayColor];
            hintLabelTitle.text = NSLocalizedString(@"Touch your camera at any time to turn on your camera.", 0);
            hintLabelTitle.frame = CGRectMake(hintLabelTitle.frame.origin.x, 10.0f, bubbleView.width, 40.0f);
            
            hintLabelDescription.frame = CGRectMake(20.0f, CGRectGetMaxY(hintLabelTitle.frame), bubbleView.width-40.0f, 60.0f);
            
            hintLabelDescription.font = [PTKFont regularFontOfSize:14.0f];
            hintLabelDescription.text = NSLocalizedString(@"When your camera is on, other room members will be able to see and hear you when they are in the room.", 0);
            
            
            PTKTriangleView* tView = [[PTKTriangleView alloc] initWithFrame:CGRectMake(CGRectGetMidX(bubbleView.frame)-10.0f, bubbleView.frame.origin.y-30.0f, 20.0f, 30.0f) pointDirection:PTKPointDirectionUp];
            [self.hintView addSubview:tView];
        }
            break;
        case PTKHintTypeOmniButton: {
            CGFloat bubbleHeight = 95.0f;
            bubbleView.frame = CGRectMake(10.0f, self.view.bounds.size.height-bubbleHeight-75.0f, self.view.width-20.0f, bubbleHeight);
            bubbleView.backgroundColor = [PTKColor darkGrayColor];
            hintLabelTitle.frame = CGRectMake(0, bubbleView.height/2-33.0f, bubbleView.width, 22.0f);
            hintLabelTitle.font = [PTKFont regularFontOfSize:14.0f];
            hintLabelDescription.frame = CGRectMake(20.0f, 60.0f, bubbleView.width-40.0f, 80.0f);
            
            
            hintLabelTitle.text = NSLocalizedString(@"Tap        button to post something", 0);
            
            UIImageView* mediaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hintLabelTitle.frame)+4, bubbleView.width, 44.0f)];
            mediaImageView.image = [UIImage imageNamed:@"education-mediasources"];
            mediaImageView.contentMode = UIViewContentModeCenter;
            [bubbleView addSubview:mediaImageView];
            
            PTKRoom *room = [[PTKWeakSharingManager roomsDataSource] objectWithId:self.roomId];
            
            CGFloat omniSize = hintLabelTitle.height*.75f;
            PTKHintMessagePropertyCell *omniView = [[PTKHintMessagePropertyCell alloc] initWithFrame:CGRectMake(CGRectGetMidX(hintLabelTitle.frame)-omniSize*5, CGRectGetMidY(hintLabelTitle.frame)-omniSize/2, omniSize, omniSize)];
            omniView.propertyImage = [UIImage imageNamed:@"info_circle"];
            omniView.propertyImageView.tintColor = room.roomColor;
            omniView.tintColor = room.roomColor;
            [bubbleView addSubview:omniView];
            
            hintLabelTitle.text = NSLocalizedString(@"Tap any button to post something", 0);
            omniView.hidden = YES;
            
            PTKTriangleView* tView = [[PTKTriangleView alloc] initWithFrame:CGRectMake(30.0f, CGRectGetMaxY(bubbleView.frame), 20.0f, 10.0f) pointDirection:PTKPointDirectionDown];
            [self.hintView addSubview:tView];
        }
            break;
        default:
            break;
    }
}



#pragma mark -

- (void)registerHintTypeAsShown:(PTKHintType)hintType {
    
    switch (hintType) {
        case PTKHintTypeSignalButton: {
            [PTKUserDefaults setValue:@1 forKey:PTKUserDefaultsHintSignal];
        }
            break;
        case PTKHintTypeVideoSwitch: {
            [PTKUserDefaults setValue:@1 forKey:PTKUserDefaultsHintVideoSwitch];
        }
            break;
        case PTKHintTypeLiveCameraPresenceAndVideoSwitch: {
            
            [PTKUserDefaults setValue:@1 forKey:PTKUserDefaultsHintCameraPresenceVideoSwitch];
        }
            break;
        case PTKHintTypePresence: {
            
            [PTKUserDefaults setValue:@1 forKey:PTKUserDefaultsHintPresence];
        }
            break;
        case PTKHintTypeOmniButton: {
            
            [PTKUserDefaults setValue:@1 forKey:PTKUserDefaultsHintOmniButton];
        }
            break;
        case PTKHintTypePlayAll: {
            
            [PTKUserDefaults setValue:@1 forKey:PTKUserDefaultsHintPlayAll];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)shouldIgnoreHintLaunchRequest:(PTKHintType)hintType {
    if (!self.roomUILayerIsVisible)
        return YES;

    BOOL ignoreHintRequest = NO;
    
    BOOL isLandscape = self.view.width > self.view.height;
    
    if (self.hintViewOnScreen) {
        ignoreHintRequest = YES;
    } else if (isLandscape) {
        ignoreHintRequest = YES;
    } else if (hintType == PTKHintTypeSignalButton) {
        //Leaving this in for when we reenable this stage
        NSNumber* object = [PTKUserDefaults objectForKey:PTKUserDefaultsHintSignal defaultTo:@0];
        if ([object boolValue]) {
            ignoreHintRequest = YES;
        }
    } else if (hintType == PTKHintTypeLiveCameraPresenceAndVideoSwitch) {
        // ignore publisher hints for self
        ignoreHintRequest = YES;
        for (PTKRoomPresence* presence in self.allMembersDataSource.activePresences) {
            if (![presence.userId isEqualToString:SELF_ID()] && presence.isPublishing) {
                ignoreHintRequest = NO;
            }
        }
        
        if (!ignoreHintRequest) {
            NSNumber * object = [PTKUserDefaults objectForKey:PTKUserDefaultsHintCameraPresenceVideoSwitch defaultTo:@0];
            if ([object boolValue]) {
                ignoreHintRequest = YES;
            }
        }
        
    } else if (hintType == PTKHintTypePresence) {
        NSNumber * object = [PTKUserDefaults objectForKey:PTKUserDefaultsHintPresence defaultTo:@0];
        if ([object boolValue]) {
            ignoreHintRequest = YES;
        }
        
    } else if (hintType == PTKHintTypeOmniButton) {
        NSNumber * object = [PTKUserDefaults objectForKey:PTKUserDefaultsHintOmniButton defaultTo:@0];
        if ([object boolValue]) {
            ignoreHintRequest = YES;
        }
    } else if (hintType == PTKHintTypePlayAll) {
        NSNumber * object = [PTKUserDefaults objectForKey:PTKUserDefaultsHintPlayAll defaultTo:@0];
        if ([object boolValue]) {
            ignoreHintRequest = YES;
        }
    } else if (hintType == PTKHintTypeVideoSwitch) {
        if (self.roomHeader.isCameraOn) {
            ignoreHintRequest = YES;
        }
        else {
            
            NSNumber * object = [PTKUserDefaults objectForKey:PTKUserDefaultsHintVideoSwitch defaultTo:@0];
            if ([object boolValue]) {
                ignoreHintRequest = YES;
            }
        }
    }
    
    return ignoreHintRequest;
}



#pragma mark -

- (void)dismissHintViewWithCompletion:(void (^)())completion {
    
    if (NILORNULL(self.hintView)) {
        if (completion) {
            completion();
        }
        return;
    }
    
    
    [UIView animateWithDuration:0.4 animations:^{
        self.hintView.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.selectedHintType == PTKHintTypePresence || self.selectedHintType == PTKHintTypeLiveCameraPresenceAndVideoSwitch) {
            [self.roomHeader setRoomPresenceFrozen:NO];
        }
        
        [self.hintView removeFromSuperview];
        self.hintView = nil;
        
        self.hintViewOnScreen = NO;
        
        if (completion) {
            completion();
        }
    }];
}

- (void)nudgeOmniButton {
    if (self.selectedHintType == PTKHintTypeOmniButton)
        [self.actionButtonsView nudgeAnimateOpenButton];
}

@end
