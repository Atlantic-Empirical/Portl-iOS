//
//  PTKAddModeratorViewController.h
//  portkey
//
//  Created by Adam Bellard on 10/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@interface PTKAddModeratorViewController : PTKBaseViewController

- (instancetype)initWithRoomId:(NSString *)roomId;

// indicates that the user is setting a mod so that they can leave the room
@property (readwrite, nonatomic) BOOL isLeaving;

@end
