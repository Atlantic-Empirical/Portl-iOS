//
//  PTKImageTableViewCell.h
//  portkey
//
//  Created by Kay Vink on 19/10/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKImageView.h" 

@interface PTKImageTableViewCell : UITableViewCell

@property (nonatomic) PTKImageView *ptkImageView;
@property (nonatomic) UIView *backgroundFill;


@end
