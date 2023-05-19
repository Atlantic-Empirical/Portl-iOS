//
//  PTKExternalDisplay.h
//  portkey
//
//  Created by Robert Reeves on 12/23/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTKYoutubePlayer.h"

@interface PTKExternalDisplay : NSObject

@property (nonatomic, strong) UIWindow *mirroredWindow;
@property (nonatomic, strong) UIScreen *mirroredScreen;
@property (nonatomic, strong) UIView *mirroredScreenView;
@property (nonatomic) PTKImageView* screenBackView;
@property (nonatomic) UIView* infoContainerView;
@property (nonatomic) UILabel* masterLabel;
@property (nonatomic) UILabel* titleLabel;
@property (nonatomic) CAGradientLayer* infoGradLayer;
@property (readonly) BOOL isExternalDisplayEnabled;


+ (PTKExternalDisplay *)sharedInstance;

- (void)setupOutputScreenWithContent:(id)content;


@end
