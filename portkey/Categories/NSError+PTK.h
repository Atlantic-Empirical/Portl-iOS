//
//  NSError+PTK.h
//  portkey
//
//  Created by Daniel Amitay on 4/29/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kPortkeyErrorDomain = @"PortkeyError";
static NSString *const kPortkeyErrorDetails = @"PortkeyErrorDetails";

// Make sure to add string representation to +errorResponseCodes in .m
typedef NS_ENUM(NSInteger, PTKErrorCode) {
    PTKErrorCodeUnknown = -1,
    PTKErrorCodeUnauthorized,
    PTKErrorCodeOutdated,
    PTKErrorCodeRateLimited,
    PTKErrorCodeInvalidPhone,
    PTKErrorCodeInvalidVerificationCode,
    PTKErrorCodeDuplicateEmail,
    PTKErrorCodeBadInput,
    PTKErrorCodeInvalidCredentials,
    PTKErrorCodeAccessTokenExpired,
    PTKErrorCodeUserNotFound,
    PTKErrorCodeRoomNotFound,
    PTKErrorCodeMalformedInput,
    PTKErrorCodeNoPermissions,
    PTKErrorCodeNotInvited,
    PTKErrorCodeRoomCountMaxed,
    PTKErrorCodeSuspended,
    PTKErrorCodeUnverifiedEmail,
    PTKErrorCodeDuplicateUsername,
    PTKErrorCodeProfaneLanguage,
    PTKErrorCodeBadRequest,
    PTKErrorCodeLastModCantLeave,
    PTKErrorCodeInvitationRequired
};


@interface NSError (PTK)

// Make a new error in our domain from an empire response
+ (NSError *)errorFromAPIResponse:(id)JSON;

// Does the error match the given code in our domain?
- (BOOL)isError:(PTKErrorCode)code;

@end
