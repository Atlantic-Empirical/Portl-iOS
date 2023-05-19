//
//  PTKTabbedViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 20/1/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"
#import "PTKTabBarView.h"

@interface PTKTabbedViewController : PTKBaseViewController

@property (assign) NSUInteger selectedIndex;
@property (readonly) UIScrollView *scrollView;
@property (readonly) PTKTabBarView *tabBar;
@property (nonatomic, strong) NSArray<PTKBaseViewController *> *viewControllers;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

@end
