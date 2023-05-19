//
//  PTKMediaTransitioningController.h
//  portkey
//
//  Created by Adam Bellard on 8/31/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PTKMediaTransitioningControllerDelegate <NSObject>

@optional
- (void)mediaTransitionAnimationEnded;

@end

@interface PTKMediaTransitioningController : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic) UIView *startingView;
@property (nonatomic) UIView *endingView;

@property (nonatomic) BOOL forcesNonInteractiveDismissal;

@property (weak, nonatomic) id<PTKMediaTransitioningControllerDelegate> delegate;

@end
