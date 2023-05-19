//
//  PTKKeychain.h
//  portkey
//
//  Created by Rodrigo Sieiro on 5/8/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKKeychain : NSObject

@property (nonatomic, strong) NSString *bearerToken;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSData *spotifySessionData;
@property (nonatomic, strong) NSData *soundCloudSessionData;
@property (nonatomic, strong) NSString *soundCloudUserId;
@property (nonatomic, strong) NSData *facebookSessionData;
@property (nonatomic, strong) NSData *googleSessionData;
@property (nonatomic, strong) NSData *vimeoSessionData;
@property (nonatomic, strong) NSData *twitchSessionData;
@property (nonatomic, strong) NSData *instagramSessionData;

@property (nonatomic) BOOL hasRequestedPushNotifications;

+ (PTKKeychain *)sharedInstance;

@end
