//
//  NSString+Util.h
//  bubonic
//
//  Created by Stanislav Nikiforov on 1/10/13.
//  Copyright (c) 2013 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSStringFromCppString(cppString) [NSString stringFromCString:cppString.c_str()]

@interface NSString (Util)

+ (NSString *)hexStringFromData:(NSData *)data;

- (BOOL)contains:(NSString *)string;
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options;

- (NSString *)firstComposedCharacter;
- (NSString *)firstWord;
- (NSString *)withCapitalizedFirstLetter;
- (NSString *)sanitizedPhoneNumber;

- (NSString *)stringByTrimmingWhiteSpace;
- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet *)charactetSet;
- (NSString *)stringByTruncatingToLength:(NSInteger)length;
- (NSString *)reversedString;

- (const char *)innerCString;
+ (NSString *)stringFromCString:(const char *)cString;

- (void)drawInRect:(CGRect)rect withFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment;

- (NSString *)SHA256;
- (NSString *)SHA256withBase64Digest;
- (NSString *)MD5;
+ (NSString *)secureFileName;

- (NSString *)stringByDecodingURLFormat;
- (NSString *)stringByEncodingURLFormat;
- (NSMutableDictionary *)dictionaryFromQueryComponents;

- (BOOL)isValidEmail;


@end
