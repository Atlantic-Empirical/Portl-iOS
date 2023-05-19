//
//  PTKSelectPeopleViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 11/12/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTKBaseTableViewController.h"

@class PTKSelectPeopleViewController;
@protocol PTKSelectPeopleViewControllerDelegate <NSObject>

- (void)selectPeople:(PTKSelectPeopleViewController *)selectPeople didSelectContacts:(NSArray *)contacts;

@end

@interface PTKSelectPeopleViewController : PTKBaseTableViewController

@property (nonatomic, weak) id<PTKSelectPeopleViewControllerDelegate> delegate;

- (instancetype)initWithContacts:(NSArray *)contacts;

@end
