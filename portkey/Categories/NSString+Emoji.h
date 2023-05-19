#import <Foundation/Foundation.h>

@interface NSString (RemoveEmoji)

- (BOOL)isIncludingEmoji;

- (BOOL)isOnlyEmoji;

- (instancetype)stringByRemovingEmoji;

- (instancetype)removedEmojiString __attribute__((deprecated));

- (NSUInteger)realLength;

@end
