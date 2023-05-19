#import "NSString+Emoji.h"

@implementation NSString (RemoveEmoji)

- (BOOL)isEmoji {
    // http://www.unicode.org/Public/UNIDATA/EmojiSources.txt
    // http://apps.timwhitlock.info/emoji/tables/unicode

    const unichar high = [self characterAtIndex: 0];
    NSUInteger len = self.length;

    if (0xD800 <= high && high <= 0xDBFF && len > 1) {
        // Surrogate pair (U+1D000-1F9FF)
        const unichar low = [self characterAtIndex: 1];
        const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;

        return (0x1D000 <= codepoint && codepoint <= 0x1F9FF);
    } else if ((0x2100 <= high && high <= 0x27FF) || (0x2900 <= high && high <= 0x2BFF)) {
        // Not surrogate pair (U+2100-27FF/U+2900-2BFF)
        return YES;
    } else if (0x0023 <= high && high <= 0x0039 && len > 1) {
        // Numbers combined with enclosing keycap
        const unichar low = [self characterAtIndex: 1];
        return low == 0xFE0F;
    }

    // Special cases
    if (high == 0x00A9) return YES;
    if (high == 0x00AE) return YES;
    if (high == 0x203C) return YES;
    if (high == 0x2049) return YES;
    if (high == 0x3030) return YES;
    if (high == 0x303D) return YES;
    if (high == 0x3297) return YES;
    if (high == 0x3299) return YES;

    return NO;
}

- (BOOL)isIncludingEmoji {
    BOOL __block result = NO;

    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
        if ([substring isEmoji]) {
            *stop = YES;
            result = YES;
        }
    }];

    return result;
}

- (BOOL)isOnlyEmoji {
    BOOL __block result = YES;

    NSCharacterSet *whitespacesAndNewlines = [NSCharacterSet whitespaceAndNewlineCharacterSet];

    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              NSString *query = [substring stringByRemovingCharactersInSet:whitespacesAndNewlines];
                              if (query.length == 0) return;

                              if (![query isEmoji]) {
                                  *stop = YES;
                                  result = NO;
                              }
                          }];
    
    return result;
}

- (instancetype)stringByRemovingEmoji {
    NSMutableString* __block buffer = [NSMutableString stringWithCapacity:[self length]];

    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
        [buffer appendString:([substring isEmoji])? @"": substring];
    }];

    return buffer;
}

- (instancetype)removedEmojiString {
    return [self stringByRemovingEmoji];
}

- (NSUInteger)realLength {
    __block NSUInteger length = 0;

    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                              length++;
                          }];
    
    return length;
}

@end
