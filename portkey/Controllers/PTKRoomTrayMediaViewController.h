//
//  PTKRoomTrayMediaViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 19/8/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@interface PTKRoomTrayMediaViewController : PTKBaseViewController

@property (nonatomic, assign) UIEdgeInsets originalInsets;

- (instancetype)initWithRoomId:(NSString *)roomId;
- (void)setRoomColor:(UIColor *)roomColor;
- (void)scrollToTop;

@end
