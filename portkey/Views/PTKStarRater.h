//
//  PTKStarRater.h
//  portkey
//
//  Created by Adam Bellard on 8/13/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKStarRater : UIControl

@property (nonatomic) int rating;
@property (nonatomic) int maxRating;
@property (nonatomic) float floatRating;
@property (nonatomic) BOOL shouldShowHalfStars;
@property (nonatomic) BOOL allowsZeroStars;

@property (nonatomic, strong) UIImage *selectedStarImage;
@property (nonatomic, strong) UIImage *deselectedStarImage;

@end
