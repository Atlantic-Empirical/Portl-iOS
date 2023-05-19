//
//  PTKPhoneUtility.h
//  portkey
//
//  Created by Daniel Amitay on 3/17/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMPhoneFormat.h"

@interface PTKPhoneUtility : NSObject

+ (NSDictionary *)countryPhoneCodes;
+ (NSString *)sanitizePhoneNumber:(NSString *)phoneNumber;
+ (NSString *)getE164PhoneNumber:(NSString *)phoneNumber withCountryCode:(NSString *)isoCountryCode;
+ (NSString *)getInternationalPhoneNumber:(NSString *)phoneNumber withCountryCode:(NSString *)isoCountryCode;
+ (NSString *)getInternationalPhoneNumberDisplay:(NSString *)internationalPhoneNumber;
+ (NSArray *)getInternationalPhoneNumberParts:(NSString *)internationalPhoneNumber;
+ (NSString *)getHomeCountryPhoneCode;
+ (NSString *)getHomeIsoCountryCode;

@end
