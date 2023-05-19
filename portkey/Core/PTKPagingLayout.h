//
//  PTKPagingLayout.h
//  portkey
//
//  Created by Rodrigo Sieiro on 9/9/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTKPagingLayoutDelegate <UICollectionViewDelegate>

@optional
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface PTKPagingLayout : UICollectionViewLayout

@property (nonatomic, weak) id<PTKPagingLayoutDelegate> delegate;

@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) BOOL snapToCells;
@property (nonatomic, readonly) NSIndexPath *currentIndexPath;

@end
