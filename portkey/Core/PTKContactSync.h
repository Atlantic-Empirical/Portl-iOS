//
//  PTKContactSync.h
//  portkey
//
//  Created by Daniel Amitay on 4/30/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKContactSync : NSObject

+ (PTKContactSync *)sharedInstance;

@property (nonatomic, readonly) NSArray *contacts;
@property (nonatomic, readonly) NSDictionary *contactsByKey;
@property (nonatomic, readonly) NSDictionary *contactsByHash;
@property (nonatomic, readonly) BOOL syncingContacts;

- (void)syncContacts;
- (UIImage *)imageForContactWithId:(NSString *)identifier;
- (void)clear;

@end
