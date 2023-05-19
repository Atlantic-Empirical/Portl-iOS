//
//  PTKAvatarCircles.h
//  portkey
//
//  Created by Rodrigo Sieiro on 19/11/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PTKCall;

@interface PTKAvatarCircles : UIControl

@property (nonatomic) BOOL grayscale;

- (void)updateWithUsers:(NSArray *)users animated:(BOOL)animated;
- (void)updateWithUsers:(NSArray *)users presences:(NSArray *)presences animated:(BOOL)animated;

@end
