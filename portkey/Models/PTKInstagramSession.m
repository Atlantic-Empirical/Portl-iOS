//
//  PTKInstagramSession.m
//  portkey
//
//  Created by Rodrigo Sieiro on 6/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKInstagramSession.h"

@implementation PTKInstagramSession

- (instancetype)initWithAccessToken:(NSString *)accessToken {
    self = [super init];
    if (!self) return nil;

    self.accessToken = accessToken;

    return self;
}

- (BOOL)isValid {
    return (self.accessToken != nil);
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.accessToken forKey:@"accessToken"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSString *accessToken = [aDecoder decodeObjectForKey:@"accessToken"];
    return [self initWithAccessToken:accessToken];
}

@end
