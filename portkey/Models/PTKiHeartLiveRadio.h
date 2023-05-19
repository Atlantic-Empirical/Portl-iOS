//
//  PTKiHeartLiveRadio.h
//  portkey
//
//  Created by Kay Vink on 02/10/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKiHeartLiveRadio : NSObject

@property (nonatomic) NSInteger id;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *subtitle;
@property (nonatomic) NSURL *logoURL;
@property (nonatomic) NSURL *streamURL;

@end