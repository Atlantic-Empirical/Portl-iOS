//
//  PTKRoomCreatorAddFriendsViewController.h
//  portkey
//
//  Created by Adam Bellard on 7/1/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"
#import "PTKRoom.h"

typedef enum {
    PTKCreateRoomStateDefault,
    PTKCreateRoomStateOnboarding
} PTKCreateRoomState;

@interface PTKRoomCreatorAddFriendsViewController : PTKBaseViewController

- (instancetype)initWithInitiallySelectedUser:(PTKContact*)userContact;

@property (readwrite) PTKCreateRoomState state;
@property (strong, nonatomic) NSString *roomTitle;
@property (strong, nonatomic) PTKRoom *room;
@property (strong, nonatomic) NSString *roomLink;

@end

