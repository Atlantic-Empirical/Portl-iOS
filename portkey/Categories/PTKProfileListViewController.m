//
//  PTKProfileListViewController.m
//  portkey
//
//  Created by Robert Reeves on 1/19/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKProfileListViewController.h"
#import "PTKPeopleCell.h"
#import "PTKProfileViewController.h"

@interface PTKProfileListViewController () <UITableViewDelegate, UITableViewDataSource, PTKPeopleCellDelegate, UISearchBarDelegate, PTKPaginatedDataSourceDelegate>

@property (nonatomic) PTKFriendsDataSource *friendsDataSource;
@property (nonatomic) NSArray* listOfFriends;
@property (nonatomic) NSArray* filteredListOfFriends;
@property (nonatomic) PTKUser* user;
@property (nonatomic) UISearchBar* searchBar;
@property (nonatomic) UITableView* tableView;

@end

@implementation PTKProfileListViewController

#pragma mark - 

- (instancetype)initWithFriends:(NSArray*)friendsList withUser:(PTKUser*)user {
 
    self = [super init];
    if (!self) return nil;
    
    self.view.backgroundColor = [PTKColor almostWhiteColor];
    self.user = user;
    self.listOfFriends = friendsList;
    self.title = localizedString(@"Friends");

    self.friendsDataSource = [PTKWeakSharingManager friendsDataSource];
    [self.friendsDataSource registerDelegate:self];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self loadContent];
    
    return self;
}

#pragma mark -

- (void)loadContentAndCustomNav {
    UIControl *backButton = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 48.0f, 30.0f)];
    [backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13.0f, 30.0f)];
    backImageView.contentMode = UIViewContentModeCenter;
    backImageView.image = [[PTKGraphics navigationBackImageWithColor:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backButton addSubview:backImageView];

    PTKImageView *avatarImageView = [[PTKImageView alloc] initWithFrame:CGRectMake(18.0f, 0, 30.0f, 30.0f)];
    [avatarImageView setImageWithAvatarForUserId:self.user.userId size:CGSizeMake(30.0f, 30.0f)];
    [backButton addSubview:avatarImageView];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)loadContent {
    
    [self loadContentAndCustomNav];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44.0f)];
    self.searchBar.alpha = 0.7f;
    [self.view addSubview:self.searchBar];
    self.searchBar.delegate = self;
    [self.searchBar setPlaceholder:localizedString(@"Search")];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.searchBar setTintColor:[PTKColor brandColor]];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.maxY, self.view.width, self.view.height-self.searchBar.maxY)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableFooterView:[[UIView alloc] init]];
    [self.view addSubview:self.tableView];
    
    
    [self.tableView registerClass:[PTKPeopleCell class] forCellReuseIdentifier:@"PTKPeopleCell"];
    
    __block NSMutableArray* newList = [NSMutableArray arrayWithCapacity:_listOfFriends.count];
    [self.listOfFriends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PTKUser* user;
        
        if ([user isKindOfClass:[PTKUser class]]) {
            
            user = (PTKUser*)user;
        }
        else if ([user isKindOfClass:[PTKContact class]]) {
            
            PTKContact* userContact = (PTKContact*)user;
            user = userContact.user;
        }
        else {
            
            user = [[PTKUser alloc] initWithJSON:obj];
        }
        
        [newList addObject:user];
    }];

    self.filteredListOfFriends = newList;
    [self.tableView reloadData];
}

#pragma mark - Status bar touch tracking

- (void)statusBarTouchedAction {
    
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    __block NSMutableArray* newList = [NSMutableArray arrayWithCapacity:_listOfFriends.count];
    [self.listOfFriends enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PTKUser* user = [[PTKUser alloc] initWithJSON:obj];
        if ([user.fullName containsString:searchText] || searchText.length < 1)
            [newList addObject:user];
    }];
    self.filteredListOfFriends = newList;
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredListOfFriends.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PTKUser* cellUser = (PTKUser*)self.filteredListOfFriends[indexPath.row];
    [self presentProfileForUser:cellUser];
}

- (void)presentProfileForUser:(PTKUser*)user {
    PTKProfileViewController* profile = [[PTKProfileViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:profile animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PTKUser *user = self.filteredListOfFriends[indexPath.row];
    PTKPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PTKPeopleCell" forIndexPath:indexPath];
    cell.showOnlineState = NO;
    cell.showCurrentRoom = NO;
    cell.delegate = self;
    [cell setPerson:user];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

#pragma mark - PTKPeopleCellDelegate

- (BOOL)peopleCell:(PTKPeopleCell *)cell isContactInvited:(PTKContact *)contact {
    return NO;
}

- (void)peopleCellDidTapAccessory:(PTKPeopleCell *)cell {
    if (cell.user) {
        if ([self.friendsDataSource hasOutgoingRequestForUserId:cell.user.oid]) {
            [self.friendsDataSource removeFriendWithId:cell.user.oid completion:nil];
        } else if (!cell.user.isSelf) {
            [self.friendsDataSource addFriendWithUser:cell.user completion:nil];
        }
    }
}

#pragma mark - PTKPaginatedDataSourceDelegate

- (void)paginatedDataSourceDidLoad:(PTKPaginatedDataSource *)dataSource {
    if (dataSource == self.friendsDataSource) {
        [self.tableView reloadData];
    }
}

#pragma mark -

- (void)dismiss {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [PTKColor almostWhiteColor];
}

- (void)viewWillLayoutSubviews {
    self.searchBar.frame = CGRectMake(0, self.topLayoutGuide.length, self.view.width, 44.0f);
    self.tableView.frame = CGRectMake(0, self.searchBar.maxY, self.view.width, self.view.height - self.bottomLayoutGuide.length - self.searchBar.maxY);
}


#pragma mark -

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
