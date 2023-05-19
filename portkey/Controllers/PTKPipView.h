//
//  PTKpipView.h
//  portkey
//
//  Created by Robert Reeves on 8/4/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PTKPipView;

@protocol PTKPipViewDelegate <NSObject>

@optional

- (void)userDidTapPipView:(PTKPipView *)pipView;

@end


@interface PTKPipView : UIView


@property (nonatomic, weak) id <PTKPipViewDelegate> delegate;

- (UIView*)visibleView;
- (void)updatePipViewWithVideoView:(UIView*)videoView;

- (void)showPipView;
- (void)hidePipView;

- (void)animatePipTouchDown;
- (void)animatePipTouchUp;

@end
