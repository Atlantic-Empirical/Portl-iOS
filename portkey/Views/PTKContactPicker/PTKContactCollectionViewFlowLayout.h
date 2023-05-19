//
//  PTKCollectionViewContactFlowLayout.h
//  PTKContactPicker
//
//  Created by Matt Bowman on 12/1/13.
//  Copyright (c) 2013 Citrrus, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTKContactCollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView*)collectionView willChangeContentSizeTo:(CGSize)newSize;

@end

@interface PTKContactCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
