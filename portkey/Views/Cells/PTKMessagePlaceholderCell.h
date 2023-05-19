//
//  PTKMessagePlaceholderCell.h
//  portkey
//
//  Created by Adam Bellard on 12/21/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseMessageCell.h"

@interface PTKMessagePlaceholderCell : PTKBaseMessageCell

@property (readwrite, nonatomic) BOOL isOwn;

- (void)startAnimating;
- (void)endAnimating;

@end
