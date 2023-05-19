//
//  PTKStreamBaseView.h
//  portkey
//
//  Created by Rodrigo Sieiro on 21/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKStreamBaseView : UIView

@property (readonly) NSString *userId;
@property (readonly) BOOL videoMuted;
@property (readonly) BOOL audioMuted;
@property (readonly) CGFloat aspectRatio;
@property (nonatomic, strong) NSString *videoGravity;

- (void)swapCameras;
- (void)swapCamerasReversed:(BOOL)reversed;
- (void)toggleAudioMute;
- (void)toggleVideoMute;
- (void)updateAspectRatio:(CGFloat)aspectRatio;

@end
