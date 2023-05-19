//
//  PTKSimpleMediaCell.h
//  portkey
//
//  Created by Rodrigo Sieiro on 6/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKSimpleMediaCell : UICollectionViewCell

@property (readonly) PTKImageView *imageView;
@property (nonatomic, assign) BOOL showPlayButton;

@end
