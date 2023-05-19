//
//  PTKSpotifyPickerViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 31/8/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@interface PTKSpotifyPickerViewController : PTKBaseViewController

- (instancetype)initWithRoomId:(NSString *)roomId;
- (void)refreshSpotifyFeaturedData;

@end
