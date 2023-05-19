//
//  UITextView (PTK).m
//  portkey
//
//  Created by Rodrigo Sieiro on 7/7/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "UITextView+PTK.h"

@implementation UITextView (PTK)

// This is needed to make Xcode View Debugger work
// http://stackoverflow.com/questions/37068231/assertion-failure-in-uitextview-firstbaselineoffsetfromtop

#ifdef DEBUG
- (void)_firstBaselineOffsetFromTop {}
- (void)_baselineOffsetFromBottom {}
#endif

@end
