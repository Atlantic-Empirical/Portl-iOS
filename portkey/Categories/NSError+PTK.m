//
//  NSError+PTK.m
//  portkey
//
//  Created by Daniel Amitay on 4/29/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "NSError+PTK.h"


@implementation NSError (PTK)

// Make sure to add enum representation to PTKErrorCode in .h
+ (NSArray *)errorResponseCodes {
    static NSArray *_errorResponseCodes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _errorResponseCodes = @[
                                @"Unauthorized",
                                @"Outdated",
                                @"RateLimited",
                                @"InvalidPhone",
                                @"InvalidVerificationCode",
                                @"DuplicateEmail",
                                @"BadInput",
                                @"InvalidCredentials",
                                @"AccessTokenExpired",
                                @"UserNotFound",
                                @"RoomNotFound",
                                @"MalformedInput",
                                @"NoPermissions",
                                @"NotInvited",
                                @"RoomCountMaxed",
                                @"Suspended",
                                @"UnverifiedEmail",
                                @"DuplicateUsername",
                                @"ProfaneLanguage",
                                @"BadRequest",
                                @"LastModCantLeave",
                                @"InvitationRequired"
                                ];
    });
    return _errorResponseCodes;
}

- (BOOL)isError:(PTKErrorCode)code {
    return [self.domain isEqualToString:kPortkeyErrorDomain] && self.code == code;
}

// Make a new error in our domain from an empire response
+ (NSError *)errorFromAPIResponse:(id)JSON {
    if (![JSON isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    NSString *code = [JSON objectForKey:@"code"];
    if (!code || ![code isKindOfClass:[NSString class]]) {
        return nil;
    }

    PTKErrorCode errorCode = [self errorCodeFromResponseCode:code];
    NSString *errorDescription = [self errorDescriptionFromErrorCode:errorCode withResponseCode:code];
    NSDictionary *userInfo = (errorDescription ? @{NSLocalizedDescriptionKey: errorDescription, kPortkeyErrorDetails: JSON} : nil);
    return [NSError errorWithDomain:kPortkeyErrorDomain
                               code:errorCode
                           userInfo:userInfo];
}

+ (PTKErrorCode)errorCodeFromResponseCode:(NSString *)string {
    NSUInteger responseCodeIndex = [[self errorResponseCodes] indexOfObject:string];
    if (responseCodeIndex == NSNotFound) {
        return PTKErrorCodeUnknown;
    } else {
        return (PTKErrorCode)responseCodeIndex;
    }
}

+ (NSString *)errorDescriptionFromErrorCode:(PTKErrorCode)errorCode withResponseCode:(NSString *)string {
    switch (errorCode) {
        case PTKErrorCodeRateLimited:
            return @"Too many requests have been performed in a short period of time";
        case PTKErrorCodeInvalidPhone:
            return @"The phone number you entered is invalid";
        case PTKErrorCodeInvalidVerificationCode:
            return @"The verification code you entered is invalid";
        case PTKErrorCodeAccessTokenExpired:
            return @"The verification code you entered has expired";
        case PTKErrorCodeUserNotFound:
            return @"That user could not be found";
        case PTKErrorCodeRoomNotFound:
            return @"That room could not be found";
        case PTKErrorCodeMalformedInput:
            return @"An error occurred while making the request";
        case PTKErrorCodeNoPermissions:
            return @"You are not allowed to do that";
        case PTKErrorCodeNotInvited:
            return @"You have not been invited";
        case PTKErrorCodeRoomCountMaxed:
            return @"You have hit the maximum number of total rooms";
        case PTKErrorCodeSuspended:
            return @"Your account is suspended";
        case PTKErrorCodeUnverifiedEmail:
            return localizedString(@"Oops something we've wrong. We don't recognize that email.");
        case PTKErrorCodeDuplicateUsername:
        case PTKErrorCodeProfaneLanguage:
            return localizedString(@"Username not available 😢");
        case PTKErrorCodeBadRequest:
            return localizedString(@"Only letters \".\", and \"_\" are allowed");
        case PTKErrorCodeLastModCantLeave:
            return localizedString(@"You're the last moderator of the room. Please add another moderator before leaving.");
        case PTKErrorCodeUnknown:
        default: {
            if (string) {
                return [NSString stringWithFormat:@"An unknown error occurred (%@)", string];
            } else {
                return @"An unknown error occurred";
            }
        }
    }
}

@end
