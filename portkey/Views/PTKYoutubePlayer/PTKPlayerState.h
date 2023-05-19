//
//  PTKPlayerState.h
//  portkey
//
//  Created by Rodrigo Sieiro on 17/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#ifndef PTKPlayerState_h
#define PTKPlayerState_h

typedef NS_ENUM(NSInteger, PTKPlayerState) {
    PTKPlayerStateUnstarted,
    PTKPlayerStateEnded,
    PTKPlayerStatePlaying,
    PTKPlayerStatePaused,
    PTKPlayerStateBuffering,
    PTKPlayerStateQueued,
    PTKPlayerStateFailed,
    PTKPlayerStateLoginNeeded,
    PTKPlayerStatePremiumRequired
};

#endif /* PTKPlayerState_h */
