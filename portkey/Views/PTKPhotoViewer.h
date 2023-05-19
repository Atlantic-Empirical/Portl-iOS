//
//  PTKPhotoViewer.h
//  portkey
//
//  Created by Rodrigo Sieiro on 30/7/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKPhotoViewer;

@protocol PTKPhotoViewerDelegate <NSObject>

@optional
- (void)photoViewer:(PTKPhotoViewer *)photoViewer didScrollToIndex:(NSInteger)index;

@end

@interface PTKPhotoViewer : UIView

@property (nonatomic, weak) id<PTKPhotoViewerDelegate> delegate;
@property (readonly) NSInteger imageCount;
@property (readonly) NSInteger currentIndex;

@property (readwrite, nonatomic) BOOL canControlStage;

- (instancetype)initWithFrame:(CGRect)frame imageInfos:(NSArray *)imageInfos;
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated userAction:(BOOL)userAction;

@end
