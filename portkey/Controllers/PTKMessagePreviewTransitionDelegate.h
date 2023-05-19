//
//  PTKMessagePreviewTransitionDelegate.h
//  portkey
//
//  Created by Adam Bellard on 9/29/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKMessagePreviewTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, readwrite) CGRect fromFrame;
@property (nonatomic, readwrite) CGFloat screenBottomPadding;
@property (nonatomic, strong) UIView *messageView;

@end
