//
//  PTKMessageMediaCell.h
//  portkey
//
//  Created by Rodrigo Sieiro on 23/8/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKMessageMedia;
@interface PTKMessageMediaCell : UICollectionViewCell

@property (readonly) PTKImageView *imageView;
@property (readonly) PTKVideoPlayer *videoPlayer;
@property (nonatomic, strong) PTKMessageMedia *media;

- (void)setupAsLoadingIndicator;
- (void)setAutoPlayState:(BOOL)autoplay;
- (void)setAvatarVisible:(BOOL)visible;

@end
