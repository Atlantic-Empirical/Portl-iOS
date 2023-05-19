//
//  PTKGenericCellDelegate.h
//  portkey
//
//  Created by Rodrigo Sieiro on 29/4/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTKGenericTableViewCellDelegate <NSObject>

@optional
- (void)tableView:(UITableView *)tableView didTapButtonAtIndex:(NSUInteger)buttonIndex forCell:(UITableViewCell *)cell;

@end

@protocol PTKGenericCollectionViewCellDelegate <NSObject>

@optional
- (void)collectionView:(UICollectionView *)collectionView didTapButtonAtIndex:(NSUInteger)buttonIndex forCell:(UICollectionViewCell *)cell;

@end
