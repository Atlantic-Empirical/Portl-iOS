//
//  PTKDatetimeUtility.h
//  portkey
//
//  Created by Rodrigo Sieiro on 24/4/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKDatetimeUtility : NSObject

+ (NSString *)formattedTimeInterval:(NSTimeInterval)interval;
+ (NSDate *)dateFromISO8601String:(NSString *)dateString;
+ (NSString *)iso8601StringFromDate:(NSDate *)date;

+ (NSString *)formattedIntervalSinceDate:(NSDate *)date;
+ (NSString *)formattedIntervalSinceDate:(NSDate *)date now:(NSString *)now suffix:(NSString *)suffix;

@end
