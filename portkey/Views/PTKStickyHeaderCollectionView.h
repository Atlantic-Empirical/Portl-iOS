//
//  PTKStickyHeaderCollectionView.h
//  portkey
//
//  Created by Rodrigo Sieiro on 17/6/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKStickyHeaderCollectionView : UICollectionView

@property (nonatomic, strong) UIView *stickyHeaderView;
@property (nonatomic) CGFloat maxHeaderHeight;
@property (nonatomic) CGFloat minHeaderHeight;
@property (nonatomic) CGFloat defaultHeaderHeight;

@end

@protocol PTKStickyHeaderCollectionViewDelegate
@optional
- (void)collectionViewDidLayoutHeader:(PTKStickyHeaderCollectionView *)collectionView;

@end
