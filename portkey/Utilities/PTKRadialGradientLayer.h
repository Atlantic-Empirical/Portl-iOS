//
//  PTKRadialGradientLayer.h
//  portkey
//
//  Created by Adam Bellard on 3/1/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PTKRadialGradientLayer : CALayer

@property(nullable, copy) NSArray *colors;
@property(nullable, copy) NSArray<NSNumber *> *locations;

@end
