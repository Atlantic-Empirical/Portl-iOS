//
//  PTKLevelsAnimationView.h
//  portkey
//
//  Created by Rodrigo Sieiro on 30/11/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKLevelsAnimationView : UIView

@property (nonatomic, readonly) BOOL isAnimating;

- (void)startAnimating;
- (void)stopAnimating;

@end
