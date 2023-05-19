//
//  PTKPlaceCurrentCollectionViewCell.h
//  portkey
//
//  Created by Robert Reeves on 9/2/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface PTKPlaceCurrentCollectionViewCell : UICollectionViewCell

@property (nonatomic) GMSMapView *googleMapView;
@property (nonatomic) UILabel* labelAddress;
@property (nonatomic) BOOL availableForAnimation;

- (void)animateZoom;

@end
