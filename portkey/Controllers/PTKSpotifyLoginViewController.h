//
//  PTKSpotifyLoginViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 4/9/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@class PTKSpotifyLoginViewController;
@protocol PTKSpotifyLoginViewControllerDelegate <NSObject>

@optional

- (void)spotifyLoginViewControllerDidCancel:(PTKSpotifyLoginViewController *)spotifyLoginViewController;
- (void)spotifyLoginViewControllerDidLogin:(PTKSpotifyLoginViewController *)spotifyLoginViewController;

@end

@interface PTKSpotifyLoginViewController : PTKBaseViewController

@property (nonatomic, weak) id<PTKSpotifyLoginViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *customTitle;
@property (nonatomic, strong) NSString *cancelButtonTitle;

@end
