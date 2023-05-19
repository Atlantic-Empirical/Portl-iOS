//
//  PTKPlaceCollectionViewCell.h
//  portkey
//
//  Created by Robert Reeves on 9/2/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PTKImageView.h"
#import "PTKStarRater.h"
#import "PTKFoursquareVenue.h"

@interface PTKPlaceCollectionViewCell : UICollectionViewCell <MKMapViewDelegate, PTKImageViewDelegate>

@property (nonatomic) PTKImageView* imageviewBackground;
@property (nonatomic) UIActivityIndicatorView* activity;
@property (nonatomic) PTKStarRater* ratingStar;
@property (nonatomic) UILabel* labelTitle;
@property (nonatomic) NSString* photoURL;
@property (nonatomic) UILabel* labelDistance;
@property (nonatomic) BOOL availableForAnimation;
@property (nonatomic) PTKPlace* place;

@end
