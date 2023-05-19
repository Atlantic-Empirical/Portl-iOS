//
//  PTKBlockedUsersViewController.m
//  portkey
//
//  Created by Robert Reeves on 1/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBlockedUsersViewController.h"
#import "PTKContactCell.h"
#import "PTKProfileViewController.h"
#import "PTKUser.h"

@interface PTKBlockedUsersViewController () <UITableViewDataSource, UITableViewDelegate, PTKPaginatedDataSourceDelegate> {
    PTKBlockedDataSource *_blockedDataSource;
    UIImage *_blockedImage;
}

@property (nonatomic) UITableView* tableView;
@property (readonly) NSArray* listOfBlockedUsers;

@end

@implementation PTKBlockedUsersViewController

static NSString *ContactCellIdentifier = @"ContactCellIdentifier";

#pragma mark - 

- (NSArray*)listOfBlockedUsers {
    NSMutableArray *blockedUsers = [[NSMutableArray alloc] init];
    for (PTKBlocked *blocked in _blockedDataSource.allObjects) {
        PTKUser *user = blocked.user;
        if (user) {
            [blockedUsers addObject:user];
        }
    }
    return blockedUsers;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _blockedImage = [PTKGraphics roundedRectImageFromImage:[PTKGraphics convertImageToGrayscale:[UIImage imageNamed:@"profile_default_avatar"]]];
    _blockedDataSource = [PTKWeakSharingManager blockedDataSource];
    [_blockedDataSource registerDelegate:self];

    self.title = localizedString(@"Blocked Users");

    [self loadTableView];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listOfBlockedUsers.count;
}


#pragma mark - UITableViewDelegate cells

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PTKContactCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:ContactCellIdentifier];
    if (cell == nil) {
        cell = [[PTKContactCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ContactCellIdentifier];
    }
    
    [cell setBlockedUserCellWithImage:_blockedImage];
    
    PTKUser* user = self.listOfBlockedUsers[indexPath.row];
    cell.textLabel.text = user.fullName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PTKUser *user = self.listOfBlockedUsers[indexPath.row];
    PTKProfileViewController* profile = [[PTKProfileViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:profile animated:YES];
}


#pragma mark -

- (void)loadTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height + 44.0f)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [PTKColor almostWhiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[PTKContactCell class] forCellReuseIdentifier:ContactCellIdentifier];
}

#pragma mark - PTKPaginatedDataSource

- (void)paginatedDataSourceDidLoad:(PTKPaginatedDataSource *)dataSource {
    [self.tableView reloadData];
}

@end
