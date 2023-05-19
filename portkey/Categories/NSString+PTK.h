//
//  NSString+PTK.h
//  portkey
//
//  Created by Daniel Amitay on 3/18/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PTK)

// Hex string from data
+ (NSString *)hexStringFromData:(NSData *)data;

// Performance helper
+ (NSString *)fastStringWithPattern:(const char * __restrict)pattern andString:(NSString *)string;

// Name validation (can all be nil)
- (NSString *)parsedFirstName;
- (NSString *)parsedLastName;
- (NSString *)parsedFullName;

@end
