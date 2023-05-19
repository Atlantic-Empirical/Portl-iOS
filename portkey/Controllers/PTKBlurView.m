//
//  PTKBlurView.m
//  portkey
//
//  Created by Robert Reeves on 4/20/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBlurView.h"

@implementation PTKBlurView


#pragma mark - 

- (id)initWithFrame:(CGRect)frame withUnderlyingView:(UIView*)view withBlurRadius:(CGFloat)blurRadius withBlurType:(PTKBlurViewType)blurType {
    
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    self.blurRadius = blurRadius;
    self.blurEnabled = YES;
    self.underlyingView = view;
    self.tintColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.dynamic = NO;
    
    if (blurType == PTKBlurViewTypeDark) {
        
        UIView* darkView = [[UIView alloc] initWithFrame:self.bounds];
        darkView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [self addSubview:darkView];
        
    }
    
    return self;
}

#pragma mark - 

- (void)setDynamic:(BOOL)dynamic {
    // for now, we're locking dynamic to NO for minimal performance implications in v2.1
    // can revisit later when a moving blurred background is necessary
    [super setDynamic:NO];
}

@end
