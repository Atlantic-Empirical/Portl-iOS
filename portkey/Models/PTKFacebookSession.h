//
//  PTKFacebookSession.h
//  portkey
//
//  Created by Rodrigo Sieiro on 21/7/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKFacebookSession : NSObject <NSCoding>

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, assign) NSTimeInterval expiresAt;

- (instancetype)initWithAccessToken:(NSString *)accessToken expiresAt:(NSTimeInterval)expiresAt;
- (BOOL)isValid;

@end
