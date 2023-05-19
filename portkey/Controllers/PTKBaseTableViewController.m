//
//  PTKBaseTableViewController.m
//  portkey
//
//  Created by Daniel Amitay on 5/11/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseTableViewController.h"

@interface PTKBaseTableViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@end

@implementation PTKBaseTableViewController

#pragma mark - Lifecycle methods

- (instancetype)init {
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithStyle:UITableViewStylePlain];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithNibName:nil bundle:nil];
    if (!self) return nil;

    _tableViewStyle = style;

    return self;
}

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}


#pragma mark - View methods

- (void)viewDidLoad {
    [super viewDidLoad];

    _clearsSelectionOnViewWillAppear = YES;

    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:self.tableViewStyle];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.frame = self.view.bounds;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.clearsSelectionOnViewWillAppear) {
        NSIndexPath *indexPathForSelectedRow = [self.tableView indexPathForSelectedRow];
        if (indexPathForSelectedRow) {
            [self.tableView deselectRowAtIndexPath:indexPathForSelectedRow animated:animated];
        }
    }
}


#pragma mark - Table view methods (should be overriden)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // This will throw an exception if not overridden
    return [UITableViewCell new];
}

@end
