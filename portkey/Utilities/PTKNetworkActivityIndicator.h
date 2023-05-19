//
//  PTKNetworkActivityIndicator.h
//  portkey
//
//  Created by Stanislav Nikiforov on 4/21/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

@interface PTKNetworkActivityIndicator : NSObject

// Add or remove a ref for the system network activity indicator. Refs disable the idle timer.
+ (void)ref;
+ (void)unref;

@end
