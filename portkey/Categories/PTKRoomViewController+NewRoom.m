//
//  PTKRoomViewController+NewRoom.m
//  portkey
//
//  Created by Adam Bellard on 5/18/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKRoomViewController+NewRoom.h"
#import "PTKRoomViewController+RoomHints.h"
#import "PTKHintMessagePropertyCell.h"

@implementation PTKRoomViewController (NewRoom)

- (void)showNewRoomSettings {
    self.hintViewOnScreen = YES;
    
    self.hintView = [[PTKHintView alloc] initWithFrame:self.view.bounds];
    self.hintView.alpha = 0;
    self.hintView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    self.hintView.userInteractionEnabled = YES;

    [self.view addSubview:self.hintView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissNewRoomInterstitial)];
    [self.hintView addGestureRecognizer:tap];
    
    
    
    // set up the "bubble" that shows room settings
    UIView *bubble = [[UIView alloc] initWithFrame:(CGRect){
        .origin.x = (self.view.width - 280.0f) / 2.0f,
        .origin.y = 120.0f,
        .size.width = 280.0f,
        .size.height = 224.0f
    }];
    bubble.layer.masksToBounds = YES;
    bubble.layer.cornerRadius = 5.0f;
    [self.hintView addSubview:bubble];

    UIVisualEffectView *bubbleBlur = [[UIVisualEffectView alloc] initWithFrame:bubble.bounds];
    [bubbleBlur setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [bubble addSubview:bubbleBlur];
    
    
    PTKRoom *room = [[PTKWeakSharingManager roomsDataSource] objectWithId:self.roomId];
    
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:(CGRect){
        .origin.x = 20.0f,
        .origin.y = 16.0f,
        .size.width = bubble.width - 40.0f,
        .size.height = 20.0f
    }];
    welcomeLabel.font = [PTKFont boldFontOfSize:17.0f];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.text = [NSString stringWithFormat:localizedString(@"Welcome to %@%@!"), (room.is1on1 && EMPTY_STR(room.title)) ? @"your 1-to-1 with " : @"", room.roomDisplayName];
    welcomeLabel.textColor = [PTKColor almostWhiteColor];
    welcomeLabel.minimumScaleFactor = 10.0f / 17.0f;
    welcomeLabel.adjustsFontSizeToFitWidth = YES;
    welcomeLabel.numberOfLines = 1;
    [bubble addSubview:welcomeLabel];
    

    // tappable room settings indicators
    PTKHintMessagePropertyCell *privacyView = [[PTKHintMessagePropertyCell alloc] initWithFrame:(CGRect) {
        .origin.x = 20.0f,
        .origin.y = welcomeLabel.maxY + 10.0f,
        .size.width = bubble.width - 40.0f,
        .size.height = 40.0f
    }];
    [privacyView addTarget:self andSelector:@selector(roomSettingsTapped)];
    [bubble addSubview:privacyView];
    
    PTKHintMessagePropertyCell *rtjView = [[PTKHintMessagePropertyCell alloc] initWithFrame:(CGRect) {
        .origin.x = 20.0f,
        .origin.y = privacyView.maxY,
        .size.width = bubble.width - 40.0f,
        .size.height = 40.0f
    }];
    rtjView.propertyImage = [UIImage imageNamed:@"rte_key"];
    [rtjView addTarget:self andSelector:@selector(roomSettingsTapped)];
    [bubble addSubview:rtjView];
    
    PTKHintMessagePropertyCell *membersView = [[PTKHintMessagePropertyCell alloc] initWithFrame:(CGRect) {
        .origin.x = 20.0f,
        .origin.y = rtjView.maxY,
        .size.width = bubble.width - 40.0f,
        .size.height = 40.0f
    }];
    membersView.propertyImage = [UIImage imageNamed:@"people"];
    [membersView addTarget:self andSelector:@selector(roomSettingsTapped)];
    [bubble addSubview:membersView];
    
    if (room && room.roomColor) {
        UIColor *highlightColor = [PTKColor highlightColorForRoomColor:room.roomColor];
        
        NSString *privacyModeText;
        if ([room isPrivate]) {
            privacyView.propertyImage = [UIImage imageNamed:@"ic_lock_25x"];
            privacyModeText = localizedString(@"ON");
        }
        else {
            privacyView.propertyImage = [UIImage imageNamed:@"ic_unlock_25x"];
            privacyModeText = localizedString(@"OFF");
        }
        NSString *privacyText = [NSString stringWithFormat:localizedString(@"Privacy mode is %@"), privacyModeText];
        NSRange modeRange = [privacyText rangeOfString:privacyModeText];
        NSMutableAttributedString *privacyAttributedText = [[NSMutableAttributedString alloc] initWithString:privacyText];
        [privacyAttributedText addAttribute:NSForegroundColorAttributeName value:highlightColor range:modeRange];
        [privacyAttributedText addAttribute:NSFontAttributeName value:[PTKFont boldFontOfSize:14.0f] range:modeRange];
        privacyView.propertyText = privacyAttributedText;
        
        NSString *rtjModeText = [room isRequestToJoin] ? localizedString(@"ON") : localizedString(@"OFF");
        NSString *rtjText = [NSString stringWithFormat:localizedString(@"Request to Join is %@"), rtjModeText];
        NSRange rtjModeRange = [rtjText rangeOfString:rtjModeText];
        NSMutableAttributedString *rtjAttributedText = [[NSMutableAttributedString alloc] initWithString:rtjText];
        [rtjAttributedText addAttribute:NSForegroundColorAttributeName value:highlightColor range:rtjModeRange];
        [rtjAttributedText addAttribute:NSFontAttributeName value:[PTKFont boldFontOfSize:14.0f] range:rtjModeRange];
        rtjView.propertyText = rtjAttributedText;
        
        membersView.propertyText = [room membersInvitesFriendsAttributedText];
    }

    // redundant continue button
    UIButton *continueButton = [[UIButton alloc] initWithFrame:(CGRect){
        .origin.x = 0.0f,
        .origin.y = bubble.height - 44.0f,
        .size.width = bubble.width,
        .size.height = 44.0f
    }];
    [continueButton setTitle:localizedString(@"CONTINUE") forState:UIControlStateNormal];
    [continueButton setTitleColor:[PTKColor redActionColor] forState:UIControlStateNormal];
    continueButton.titleLabel.font = [PTKFont boldFontOfSize:17.0f];
    continueButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    [bubble addSubview:continueButton];
    [continueButton addTarget:self action:@selector(dismissNewRoomInterstitial) forControlEvents:UIControlEventTouchUpInside];
    
    
    // Set user default so that we dont show the message hint again
    NSString *shouldShowMessageHintKey = [NSString stringWithFormat:@"%@:%@", [PTKUserDefaults keyNameFromKey:PTKUserDefaultsSessionKeyDidShowMessageHint], self.roomId];
    [PTKUserDefaults setValue:nil forKeyString:shouldShowMessageHintKey synchronize:NO];
    
    // animate completed view in
    [UIView animateWithDuration:0.4 animations:^{
        self.hintView.alpha = 1;
    }];
}

#pragma mark - actions

- (void)dismissNewRoomInterstitial {
    [UIView animateWithDuration:0.4 animations:^{
        self.hintView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.hintView removeFromSuperview];
        self.hintView = nil;
        
        self.hintViewOnScreen = NO;

        // show the omni tray hint if it hasn't been shown before
        [self launchHintView:PTKHintTypeOmniButton relatedUserId:nil];
    }];
}

- (void)roomSettingsTapped {
    [self dismissNewRoomInterstitial];
    [self openRoomSettings];
}

@end
