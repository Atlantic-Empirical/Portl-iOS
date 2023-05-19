//
//  PTKDownloadProgressViewController.h
//  portkey
//
//  Created by Adam Bellard on 11/9/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@protocol PTKDownloadProgressViewControllerDelegate <NSObject>

- (void)downloadProgressViewControllerWantsToCancelDownload;

@end

@interface PTKDownloadProgressViewController : PTKBaseViewController

@property (weak, nonatomic) id<PTKDownloadProgressViewControllerDelegate> delegate;

- (void)setProgress:(float)progress;

@end
