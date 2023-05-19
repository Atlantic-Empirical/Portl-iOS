//
//  PTKMediaCell.h
//  portkey
//
//  Created by Rodrigo Sieiro on 12/5/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

@import Photos;
#import <UIKit/UIKit.h>

@interface PTKMediaCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic) BOOL availableForAnimation;

@end
