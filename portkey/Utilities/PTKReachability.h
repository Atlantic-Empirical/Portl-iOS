//
//  PTKReachability.h
//  portkey
//
//  Created by Stanislav Nikiforov on 4/22/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

@interface PTKReachability : NSObject

+ (PTKReachability *)sharedInstance;

- (BOOL)isReachable;
- (BOOL)isWifiReachable;

@end
