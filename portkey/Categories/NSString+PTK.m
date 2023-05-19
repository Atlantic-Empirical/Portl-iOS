//
//  NSString+PTK.m
//  portkey
//
//  Created by Daniel Amitay on 3/18/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "NSString+PTK.h"

@implementation NSString (PTK)

// Returns hexadecimal string of NSData. Empty string if data is empty.
+ (NSString *)hexStringFromData:(NSData *)data {
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    if (!dataBuffer) {
        return [[NSString alloc] init];
    }
    NSUInteger dataLength  = [data length];
    NSMutableString *hexString = [[NSMutableString alloc] initWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }
    return [[NSString alloc] initWithString:hexString];
}


// Performance helper
+ (NSString *)fastStringWithPattern:(const char * __restrict)pattern andString:(NSString *)string {
    char *buffer;
    asprintf(&buffer, pattern, [string UTF8String]);
    NSString *final = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    free(buffer);
    return final;
}


#pragma mark - Name validation

- (NSString *)parsedFirstName {
    NSString *trimmed = [self stringByTrimmingWhiteSpace];
    NSArray *nameComponents = [trimmed componentsSeparatedByString:@" "];
    // A person's first name is simply the first word before a space character
    return nameComponents.firstObject;
}

- (NSString *)parsedLastName {
    NSString *trimmed = [self stringByTrimmingWhiteSpace];
    NSArray *nameComponents = [trimmed componentsSeparatedByString:@" "];
    if (nameComponents.count < 2) {
        return nil;
    } else {
        // A person's last name is every word after the first space character
        NSArray *lastNameComponents = [nameComponents subarrayWithRange:NSMakeRange(1, nameComponents.count - 1)];
        NSMutableArray *finalLastNameComponents = [[NSMutableArray alloc] initWithCapacity:lastNameComponents.count];
        for (NSString *component in lastNameComponents) {
            if (component.length) {
                [finalLastNameComponents addObject:component];
            }
        }
        return [finalLastNameComponents componentsJoinedByString:@" "];
    }
}

- (NSString *)parsedFullName {
    NSMutableArray *nameComponents = [[NSMutableArray alloc] init];
    NSString *firstName = [self parsedFirstName];
    NSString *lastName = [self parsedLastName];
    if (firstName) {
        [nameComponents addObject:firstName];
    }
    if (lastName) {
        [nameComponents addObject:lastName];
    }
    if (nameComponents.count == 0) {
        return nil;
    }
    return [nameComponents componentsJoinedByString:@" "];
}

@end
