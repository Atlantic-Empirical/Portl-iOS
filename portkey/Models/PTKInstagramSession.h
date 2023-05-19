//
//  PTKInstagramSession.h
//  portkey
//
//  Created by Rodrigo Sieiro on 6/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKInstagramSession : NSObject <NSCoding>

@property (nonatomic, copy) NSString *accessToken;

- (instancetype)initWithAccessToken:(NSString *)accessToken;
- (BOOL)isValid;

@end
