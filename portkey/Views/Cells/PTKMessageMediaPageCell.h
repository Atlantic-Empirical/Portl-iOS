//
//  PTKMessageMediaPageCell.h
//  portkey
//
//  Created by Rodrigo Sieiro on 9/9/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKMessageMedia;
@interface PTKMessageMediaPageCell : UICollectionViewCell

@property (readonly) PTKImageView *imageView;
@property (nonatomic, strong) PTKMessageMedia *media;

@end
