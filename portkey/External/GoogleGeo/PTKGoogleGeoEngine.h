//
//  PTKGoogleGeoEngine.h
//  portkey
//
//  Created by Robert Reeves on 10/29/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PTKGoogleGeoPlace, CLLocation;

typedef void (^PTKGoogleGeoArrayCompletionBlock)(NSError *error, NSArray *items);
typedef void (^PTKGoogleGeoPlaceCompletionBlock)(NSError *error, PTKGoogleGeoPlace *item);


@interface PTKGoogleGeoEngine : NSObject


+ (PTKGoogleGeoEngine *)sharedInstance;

- (void)retrieveGoogleGeoResultForQuery:(NSString*)query completion:(PTKGoogleGeoArrayCompletionBlock)completion;


@end
