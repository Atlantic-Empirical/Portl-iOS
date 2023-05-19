//
//  PTKPushPopAnimator.h
//  portkey
//
//  Created by Rodrigo Sieiro on 17/11/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKPushPopAnimator : UIPercentDrivenInteractiveTransition <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL dismissing;
@property (nonatomic, assign) BOOL percentageDriven;

@end