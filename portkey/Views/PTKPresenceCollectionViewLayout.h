//
//  PTKPresenceCollectionViewLayout.h
//  portkey
//
//  Created by Seth Samuel on 12/19/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKPresenceCollectionViewLayout : UICollectionViewFlowLayout

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath withContentOffset:(CGPoint)offset;

@end
