//
//  PTKBaseExternalAPI.h
//  portkey
//
//  Created by Kay Vink on 20/10/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import "PTKAPI.h"

@interface PTKExternalAPI : NSObject

#pragma mark State management

+ (void)cancelAllOperations;

+ (PTKAPIRequest *)performExternalRequest:(NSMutableURLRequest *)request callback:(PTKAPICallback*)callback;

+ (PTKAPIRequest *)makeDelete:(NSString *)urlString params:(id <NSCoding>)params callback:(PTKAPICallback *)callback;
+ (PTKAPIRequest *)makeGet:(NSString *)urlString params:(id <NSCoding>)params callback:(PTKAPICallback *)callback;
+ (PTKAPIRequest *)makePost:(NSString *)urlString params:(id <NSCoding>)params callback:(PTKAPICallback *)callback;
+ (PTKAPIRequest *)makePut:(NSString *)urlString params:(id <NSCoding>)params callback:(PTKAPICallback *)callback;

@end
