//
//  PTKMention.h
//  portkey
//
//  Created by Daniel Amitay on 6/7/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@interface PTKMention : PTKModel

- (NSString *)userId;
- (int)start;
- (int)end;
- (NSRange)range;

- (instancetype)initWithUserId:(NSString *)userId andRange:(NSRange)range;

@end
