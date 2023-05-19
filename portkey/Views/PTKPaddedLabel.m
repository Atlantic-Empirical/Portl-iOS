//
//  PTKPaddedLabel.m
//  portkey
//
//  Created by Seth Samuel on 1/13/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKPaddedLabel.h"

@implementation PTKPaddedLabel

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.padding)];
}

- (CGSize)intrinsicContentSize {
    CGSize contentSize = [super intrinsicContentSize];
    return CGSizeMake(contentSize.width + self.padding.left + self.padding.right, contentSize.height + self.padding.top + self.padding.bottom);
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize contentSize = [super sizeThatFits:CGSizeMake(size.width - self.padding.left - self.padding.right, size.height - self.padding.top - self.padding.bottom)];
    return CGSizeMake(contentSize.width + self.padding.left + self.padding.right, contentSize.height + self.padding.top + self.padding.bottom);
}
@end
