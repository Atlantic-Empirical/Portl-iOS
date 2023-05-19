//
//  PTKRoomAcceptViewController.h
//  portkey
//
//  Created by Adam Bellard on 2/24/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

typedef NS_ENUM(NSUInteger, PTKRoomAcceptType) {
    PTKRoomAcceptTypeDefault,
    PTKRoomAcceptTypeParty,
    PTKRoomAcceptTypeSuperSignal,
};

@interface PTKRoomAcceptViewController : PTKBaseViewController

- (instancetype)initWithRoom:(PTKRoom *)room acceptType:(PTKRoomAcceptType)acceptType signalingUserId:(NSString *)signalingUserId dismissCompletion:(void (^)())dismissCompletion acceptCompletion:(void (^)())acceptCompletion;

@property (strong, nonatomic) PTKUser *signalingUser;

@end
