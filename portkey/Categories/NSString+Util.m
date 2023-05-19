//
//  NSString+Util.m
//  bubonic
//
//  Created by Stanislav Nikiforov on 1/10/13.
//  Copyright (c) 2013 Airtime Media. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+Util.h"
#import <CommonCrypto/CommonHMAC.h>
@implementation NSString (Util)

+ (NSCharacterSet *)nonPhoneNumberCharacters {
    static NSCharacterSet *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NSCharacterSet characterSetWithCharactersInString:@"+0123456789"] invertedSet];
    });
    return sharedInstance;
}

- (BOOL)contains:(NSString *)string {
    return [self containsString:string options:kNilOptions];
}

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options {
    if (!string) {
        return NO;
    }
    return [self rangeOfString:string options:options].location != NSNotFound;
}

- (NSString *)firstComposedCharacter {
    __block NSString *firstLetter = nil;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length)
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              firstLetter = [substring uppercaseString];
                              *stop = YES;
                          }];
    return firstLetter;
}

- (NSString *)firstWord {
    NSRange firstSpace = [self rangeOfString:@" "];
    if (firstSpace.length == 0) {
        return self;
    } else {
        return [self substringToIndex:firstSpace.location];
    }
}

- (NSString *)withCapitalizedFirstLetter {
    if (!self.length) return [self copy];

    NSString *firstChar = [self substringToIndex:1];
    return [firstChar stringByAppendingString:[self substringFromIndex:1]];
}

- (NSString *)sanitizedPhoneNumber {
    return [self stringByRemovingCharactersInSet:[NSString nonPhoneNumberCharacters]];
}

- (NSString *)stringByTrimmingLeadingWhiteSpace {
    NSInteger i = 0;

    while (i < [self length] && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }

    return [self substringFromIndex:i];
}

- (NSString *)stringByTrimmingTailWhiteSpace {
    NSInteger i = [self length] - 1;

    while (i >= 0 && [[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i--;
    }

    return [self substringToIndex:(i + 1)];
}

- (NSString *)stringByTrimmingWhiteSpace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet *)charactetSet {
    NSCharacterSet *invertedSet = [charactetSet invertedSet];
    NSMutableString *cleanString = [NSMutableString stringWithCapacity:self.length];
    NSScanner *scanner = [NSScanner scannerWithString:self];

    while (![scanner isAtEnd]) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:invertedSet intoString:&buffer]) {
            [cleanString appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }

    return cleanString;
}

- (NSString *)stringByTruncatingToLength:(NSInteger)length {
    if (self.length <= length) {
        return self;
    } else {
        return [[NSString alloc] initWithFormat:@"%@...", [self substringToIndex:length]];
    }
}

- (NSString *)reversedString {
    NSInteger len = self.length;
    NSMutableString *reversed = [[NSMutableString alloc] initWithCapacity:len];

    while (len > 0) {
        [reversed appendFormat:@"%C", [self characterAtIndex:--len]];
    }

    return reversed;
}

+ (NSString *)stringFromCString:(const char *)cString {
    return [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
}

- (const char *)innerCString {
    if (self == nil) {
        return "";
    }
    return [self cStringUsingEncoding:NSUTF8StringEncoding];
}

/**
 * Draws the string using the specified bounding rectangle, line spacing, and
 * alignment. Runs of whitespace are collapsed into one space, lines break at
 * word boundaries to rect.size.width, and the last line truncated and drawn
 * with an ellipsis if necessary.
 */
- (void)drawInRect:(CGRect)rect
          withFont:(UIFont *)font
       lineSpacing:(CGFloat)lineSpacing
         alignment:(NSTextAlignment)alignment {
    NSArray *tokens = [self componentsSeparatedByCharactersInSet:
                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableString *cur;
    NSUInteger pos = 0;
    CGRect curRect = rect;
    curRect.size.height = font.lineHeight;

    while (pos < tokens.count) {
        if (curRect.origin.y + curRect.size.height + lineSpacing >
            rect.origin.y + rect.size.height) {
            // if next line would be outside rect
            NSString *last = [[tokens subarrayWithRange:NSMakeRange(pos, tokens.count - pos)]
                              componentsJoinedByString:@" "];

            NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            paragraphStyle.alignment = alignment;
            [last drawInRect:curRect withAttributes:@{NSFontAttributeName: font,
                                                      NSParagraphStyleAttributeName: paragraphStyle}];
            return;
        }

        cur = [NSMutableString stringWithCapacity:self.length];
        NSUInteger lastGoodIndex;
        while (pos < tokens.count) {
            lastGoodIndex = cur.length;
            if (cur.length > 0) {
                [cur appendString:@" "];
            }
            [cur appendString:[tokens objectAtIndex:pos]];


            if ([cur sizeWithAttributes:@{NSFontAttributeName: font}].width <= rect.size.width) {
                ++pos;
            } else {
                [cur deleteCharactersInRange:NSMakeRange(lastGoodIndex, cur.length - lastGoodIndex)];
                break;
            }
        }

        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.alignment = alignment;
        [cur drawInRect:curRect withAttributes:@{NSFontAttributeName: font,
                                                 NSParagraphStyleAttributeName: paragraphStyle}];

        curRect.origin.y += lineSpacing;
    }
}

- (NSString *)SHA256 {
    const char *str = [self UTF8String];
    unsigned char result[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG) strlen(str), result);

    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH*2];
    for ( int i=0; i<CC_SHA256_DIGEST_LENGTH; i++ ) {
        [ret appendFormat:@"%02x",result[i]];
    }

    return ret;
}

- (NSString *)SHA256withBase64Digest {
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];

    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *base64 = [out base64EncodedStringWithOptions:kNilOptions];
    return base64;
}

- (NSString *)MD5 {
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];

    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);

    static const char HexEncodeChars[] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
    char *outputData = malloc(CC_MD5_DIGEST_LENGTH * 2 + 1);

    // Convert MD5 value in the buffer to NSString of hex values
    for (uint index = 0; index < CC_MD5_DIGEST_LENGTH; index++) {
        outputData[index * 2] = HexEncodeChars[(md5Buffer[index] >> 4)];
        outputData[index * 2 + 1] = HexEncodeChars[(md5Buffer[index] % 0x10)];
    }
    outputData[CC_MD5_DIGEST_LENGTH * 2] = 0;

    NSString *output = [NSString stringWithCString:outputData encoding:NSASCIIStringEncoding];
    free(outputData);
    return output;
}

+ (NSString *)secureFileName {
    uint32_t rand1 = arc4random();
    uint32_t rand2 = arc4random();
    uint32_t rand3 = arc4random();
    uint32_t rand4 = arc4random();

    return [NSString stringWithFormat:@"%x%x%x%x_%f", rand1, rand2, rand3, rand4, NOW()];
}

/* Returns hexadecimal string of NSData. Empty string if data is empty. */
+ (NSString *)hexStringFromData:(NSData *)data {
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];

    if (!dataBuffer) {
        return [NSString string];
    }

    NSUInteger dataLength  = [data length];
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];

    for (int i = 0; i < dataLength; ++i) {
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    }

    return [NSString stringWithString:hexString];
}

- (NSString *)stringByDecodingURLFormat {
    NSString *result = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByRemovingPercentEncoding];
    return result;
}

- (NSString *)stringByEncodingURLFormat {
    NSString *result = [self stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    result = [result stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    return result;
}

- (NSMutableDictionary *)dictionaryFromQueryComponents {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        if (elements.count == 2) {
            NSString *key = elements[0];
            NSString *value = elements[1];
            NSString *decodedKey = [key stringByDecodingURLFormat];
            NSString *decodedValue = [value stringByDecodingURLFormat];
            if (![key isEqualToString:decodedKey])
                key = decodedKey;
            
            if (![value isEqualToString:decodedValue])
                value = decodedValue;
            
            [dictionary setObject:value forKey:key];
        }
    }
    return dictionary;
}


- (BOOL)isValidEmail
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}


@end
