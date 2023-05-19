//
//  PTKAudioRecorderViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 11/8/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@class PTKAudioRecorderViewController;
@protocol PTKAudioRecorderViewControllerDelegate <NSObject>

@required
- (CGRect)frameForAudioRecorderBorder:(PTKAudioRecorderViewController *)audioRecorder;

@end

@interface PTKAudioRecorderViewController : PTKBaseViewController

@property (nonatomic, strong) UIColor *roomColor;
@property (nonatomic, weak) id<PTKAudioRecorderViewControllerDelegate> delegate;

- (instancetype)initWithRoomId:(NSString *)roomId;

@end
