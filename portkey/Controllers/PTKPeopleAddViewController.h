//
//  PTKPeopleAddViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 6/2/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKBaseTableViewController.h"

@protocol PTKPeopleAddDelegate <NSObject>

@optional
- (void)peopleAddDidSelectOptionAtIndex:(NSUInteger)index;

@end

@interface PTKPeopleAddViewController : PTKBaseTableViewController

@property (nonatomic, weak) id<PTKPeopleAddDelegate> delegate;

- (CGFloat)expectedHeight;

@end
