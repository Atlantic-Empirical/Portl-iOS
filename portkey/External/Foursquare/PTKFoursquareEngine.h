//
//  PTKFoursquareEngine.h
//  portkey
//
//  Created by Rodrigo Sieiro on 2/7/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTKFoursquareVenue, CLLocation;

typedef void (^PTKFoursquareArrayCompletionBlock)(NSError *error, NSArray *items);
typedef void (^PTKFoursquareVenueCompletionBlock)(NSError *error, PTKFoursquareVenue *item);

@interface PTKFoursquareEngine : NSObject

+ (PTKFoursquareEngine *)sharedInstance;
- (void)placesForLocation:(CLLocation *)location query:(NSString *)query completion:(PTKFoursquareArrayCompletionBlock)completion;
- (void)placeWithId:(NSString *)placeId completion:(PTKFoursquareVenueCompletionBlock)completion;
- (void)explorePlacesForLocation:(CLLocation *)location query:(NSString *)query completion:(PTKFoursquareArrayCompletionBlock)completion;

@end
