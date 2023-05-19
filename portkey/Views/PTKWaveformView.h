//
//  PTKWaveformView.h
//  portkey
//
//  Created by Rodrigo Sieiro on 11/8/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKWaveformView;
@protocol PTKWaveformViewDelegate <NSObject>

@optional
- (void)waveFormView:(PTKWaveformView *)waveFormView didFinishRenderingImage:(UIImage *)image;

@end

@interface PTKWaveformView : UIView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readonly) BOOL isRendering;
@property (nonatomic, weak) id<PTKWaveformViewDelegate> delegate;

- (void)renderAudioFile:(NSURL *)fileURL;
- (void)setProgress:(double)progress;

@end
