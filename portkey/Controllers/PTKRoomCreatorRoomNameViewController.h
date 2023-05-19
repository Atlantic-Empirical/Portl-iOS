//
//  PTKRoomCreatorRoomNameViewController.h
//  portkey
//
//  Created by Adam Bellard on 6/30/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"
#import "PTKRoom.h"

@interface PTKRoomCreatorRoomNameViewController : PTKBaseViewController

- (instancetype)initWithInitiallySelectedUser:(PTKContact*)userContact;

@property (nonatomic, strong) PTKRoom *room;
@property (nonatomic, strong) NSString *roomTitle;

@end
