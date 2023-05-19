//
//  PTKAddModeratorViewController.m
//  portkey
//
//  Created by Adam Bellard on 10/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKAddModeratorViewController.h"
#import "PTKRoomModeratorDataSource.h"
#import "PTKOnlinePresenceDataSource.h"
#import "PTKContactCell.h"
#import "portkey-Swift.h"

NS_ENUM(NSInteger, PTKAddModeratorSection) {
    PTKAddModeratorSectionModerators,
    PTKAddModeratorSectionMembers,
    PTKAddModeratorSectionCount
};

@interface PTKAddModeratorViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, PTKPaginatedDataSourceDelegate, PTKOnlinePresenceDataSourceDelegate> {
    NSString *_roomId;
    UIColor *_roomColor;
    PTKRoomModeratorDataSource *_moderatorDataSource;
    PTKRoomPresenceDataSource *_roomPresenceDataSource;
    PTKOnlinePresenceDataSource *_onlineDataSource;
    
    UINavigationBar *_customNavBar;
    
    UITextField *_searchTextField;

    UITableView *_tableView;
    
    NSMutableArray *_moderators;
    NSMutableArray *_members;
    
    NSArray *_filteredModerators;
    NSArray *_filteredMembers;
    
    NSMutableArray *_addingModerators;
    
    BOOL _cancelAddModerators;
}

@end

@implementation PTKAddModeratorViewController

- (instancetype)initWithRoomId:(NSString *)roomId {
    self = [super init];
    
    if (self) {
        _roomId = roomId;
        
        _moderatorDataSource = [PTKWeakSharingManager moderatorDataSourceForRoom:_roomId];
        [_moderatorDataSource registerDelegate:self];
        
        _roomPresenceDataSource = [PTKWeakSharingManager presenceDataSourceForRoom:_roomId];
        [_roomPresenceDataSource registerDelegate:self];
        if (!_roomPresenceDataSource.didFetch) {
            [_roomPresenceDataSource reload];
        }
        
        _onlineDataSource = [[PTKOnlinePresenceDataSource alloc] init];
        _onlineDataSource.delegate = self;
        
        _moderators = [[NSMutableArray alloc] init];
        
        _cancelAddModerators = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [PTKColor almostWhiteColor];
    
    
    // Custom navigation bar
    _customNavBar = [[UINavigationBar alloc] initWithFrame:(CGRect){
        .size.width = self.view.width,
        .size.height = 44.0f
    }];
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:localizedString(@"Add Moderators")];
    UIImage *backImage = [PTKGraphics navigationBackImageWithColor:nil];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction:)];
    navItem.leftBarButtonItem = closeButton;
    [_customNavBar pushNavigationItem:navItem animated:NO];
    [_customNavBar setBackgroundImage:[PTKGraphics imageWithColor:[PTKColor almostWhiteColor]] forBarMetrics:UIBarMetricsDefault];
    [_customNavBar setShadowImage:[UIImage new]];
    [self.view addSubview:_customNavBar];
    
    
    // Search field
    CGFloat searchY = 44.0f;
    
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, searchY, self.view.width - 40.0f, 44.0f)];
    _searchTextField.delegate = self;
    _searchTextField.backgroundColor = [UIColor clearColor];
    _searchTextField.font = [PTKFont regularFontOfSize:14.0f];
    
    NSMutableAttributedString *place = [[NSMutableAttributedString alloc] initWithString:localizedString(@"Search Members")];
    [place addAttribute:NSFontAttributeName
                  value:[PTKFont regularFontOfSize:14.0f]
                  range:NSMakeRange(0, place.length)];
    [place addAttribute:NSForegroundColorAttributeName
                  value:[PTKColor grayColor]
                  range:NSMakeRange(0, place.length)];
    _searchTextField.attributedPlaceholder = place;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    PTKImageView *imageView = [[PTKImageView alloc] initWithImage:[[UIImage imageNamed:@"ic_search-22x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    imageView.contentMode = UIViewContentModeLeft;
    imageView.frame = CGRectMake(0, -1, 35.0f, 18.0f);
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30.0f, 18.0f)];
    [paddingView addSubview:imageView];
    _searchTextField.leftView = paddingView;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:_searchTextField];
    
    [self listenFor:UITextFieldTextDidChangeNotification selector:@selector(textFieldDidChange:)];
    

    // Table view
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){
        .origin.y = _searchTextField.maxY,
        .size.width = self.view.width,
        .size.height = self.view.height - _searchTextField.maxY
    }];
    _tableView.backgroundColor = [PTKColor almostWhiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[PTKContactCell class] forCellReuseIdentifier:@"CellModerator"];
    [_tableView registerClass:[PTKContactCell class] forCellReuseIdentifier:@"CellMember"];

    [PTKEventTracker track:PTKEventTypeRoomManagerModeratorAddLoaded];
    
    PTKRoom *room = [[PTKWeakSharingManager roomsDataSource] objectWithId:_roomId];
    [self updateWithRoomColor:room.roomColor];
    
    [self loadModeratorsAndMembers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_moderatorDataSource reload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Force update just in case
    _onlineDataSource.sleep = YES;
    _onlineDataSource.sleep = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doneAction:(id)sender {
    [self showSpinner];
    _addingModerators = [_moderators mutableCopy];
    
    _cancelAddModerators = NO;
    for (PTKUser *user in _moderators) {
        [PTKEventTracker track:PTKEventTypeRoomManagerModeratorAdded withProperties:@{@"userId":user.userId}];
        
        PTKAPICallback *callback = [[PTKAPICallback alloc] initWithTarget:self selector:@selector(onDidAddModerator:) userInfo:@{kKeyUser : user}];
        [PTKAPI addModerator:user.userId toRoom:_roomId callback:callback];
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - state update methods

- (void)updateWithRoomColor:(UIColor *)roomColor {
    roomColor = [roomColor readableColor];
    
    if (roomColor) {
        _customNavBar.titleTextAttributes = @{NSForegroundColorAttributeName: roomColor};
    }
    
    if (![_customNavBar.topItem.leftBarButtonItem.title isEqualToString:localizedString(@"Cancel")]) {
        _customNavBar.topItem.leftBarButtonItem.tintColor = roomColor;
        _customNavBar.topItem.rightBarButtonItem.tintColor = roomColor;
    }

    _searchTextField.tintColor = roomColor;
    
    for (UITableViewCell *cell in _tableView.visibleCells) {
        if ([cell.reuseIdentifier isEqualToString:@"CellModerator"]) {
            cell.tintColor = roomColor;
        }
    }
    
    _roomColor = roomColor;
}

- (void)loadModeratorsAndMembers {
    if (_members == nil) {
        // create the members array and add non-mod members to it
        
        _members = [[NSMutableArray alloc] init];
        for (PTKRoomMember *member in _roomPresenceDataSource.allMembers) {
            if (![_moderatorDataSource userIsModerator:member.user.userId]) {
                [_members addObject:member.user];
            }
        }
    }
    else {
        // add any newly added non-mod members
        
        for (PTKRoomMember *member in _roomPresenceDataSource.allMembers) {
            if (![_moderatorDataSource userIsModerator:member.user.userId]) {
                BOOL foundUser = NO;
                for (PTKUser *user in _members) {
                    if ([user.userId isEqualToString:member.user.userId]) {
                        foundUser = YES;
                        break;
                    }
                }
                
                for (PTKUser *moderator in _moderators) {
                    if ([moderator.userId isEqualToString:member.user.userId]) {
                        foundUser = YES;
                        break;
                    }
                }
                
                if (!foundUser) {
                    [_members addObject:member.user];
                }
            }
        }
    }
    
    NSString *searchString = [_searchTextField.text stringByTrimmingWhiteSpace];
    if (searchString.length > 2 && [[searchString substringToIndex:2] isEqualToString:@"00"]) {
        NSRange range = NSMakeRange(0,2);
        searchString = [searchString stringByReplacingCharactersInRange:range withString:@"+"];
    }
    
    if (!searchString.length) {
        _filteredMembers = _members;
        _filteredModerators = _moderators;
    } else {
        NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(PTKUser *user, NSDictionary *bindings) {
            return user.sortingName.length && ([user matchesSearchString:searchString] || [user matchesUsernameSearchString:searchString]);
        }];
        _filteredMembers = [_members filteredArrayUsingPredicate:filterPredicate];
        _filteredModerators = [_moderators filteredArrayUsingPredicate:filterPredicate];
    }

    NSArray *observingUsers = [_filteredMembers arrayByAddingObjectsFromArray:_filteredModerators];
    NSMutableSet *observingContacts = [NSMutableSet setWithCapacity:observingUsers.count];
    for (PTKUser *user in observingUsers) {
        [observingContacts addObject:[[PTKContact alloc] initWithUser:user]];
    }
    
    [_onlineDataSource setObservingContacts:observingContacts];

    [_tableView reloadData];
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    // TODO: possible instrumentation
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    // TODO: possible instrumentation
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // TODO: possible instrumentation
}

- (void)textFieldDidChange:(NSNotification *)notification {
    [self loadModeratorsAndMembers];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchTextField resignFirstResponder];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == PTKAddModeratorSectionModerators && _filteredModerators.count > 0) {
        return 20.0f;
    }
    if (section == PTKAddModeratorSectionMembers && _filteredMembers.count > 0) {
        return 20.0f;
    }
    
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title;
    if (section == PTKAddModeratorSectionModerators) {
        title = localizedString(@"MODERATORS");
    }
    else if (section == PTKAddModeratorSectionMembers) {
        title = localizedString(@"MEMBERS");
    }
    else {
        return [[UIView alloc] init];
    }
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, 15.0f)];
    header.backgroundColor = [PTKColor almostWhiteColor];
    
    UILabel *settingsLabel = [[UILabel alloc] init];
    settingsLabel.attributedText = [[NSAttributedString alloc] initWithString:title
                                                                   attributes:@{NSKernAttributeName : @1.5}];
    settingsLabel.textColor = [PTKColor settingsHeaderTextColor];
    settingsLabel.textAlignment = NSTextAlignmentCenter;
    settingsLabel.font = [PTKFont mediumFontOfSize:11.0f];
    settingsLabel.backgroundColor = [PTKColor almostWhiteColor];
    [settingsLabel sizeToFit];
    settingsLabel.frame = CGRectMake(0.0f, 0.0f, settingsLabel.width + 10.0f, settingsLabel.height);
    settingsLabel.center = header.center;
    settingsLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    settingsLabel.layer.cornerRadius = settingsLabel.height / 2.0f;
    settingsLabel.layer.masksToBounds = YES;
    [header addSubview:settingsLabel];
    
    UIView *labelSeparator = [[UIView alloc] init];
    labelSeparator.backgroundColor = [PTKColor settingsSeparatorColor];
    labelSeparator.frame = (CGRect) {
        .origin.x = 20.0f,
        .origin.y = header.height / 2.0f,
        .size.width = header.width - 40.0f,
        .size.height = [PTKGraphics onePixelAtAnyScale]
    };
    labelSeparator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [header insertSubview:labelSeparator belowSubview:settingsLabel];
    
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return PTKAddModeratorSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == PTKAddModeratorSectionModerators) {
        return _filteredModerators.count;
    }
    else if (section == PTKAddModeratorSectionMembers) {
        return _filteredMembers.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PTKAddModeratorSectionModerators) {
        PTKContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellModerator"];
        if (!cell) {
            cell = [[PTKContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellModerator"];
        }
        
        PTKUser *moderator = _filteredModerators[indexPath.row];
        PTKContact *contact = [[PTKContact alloc] initWithUser:moderator];
        
        cell.backgroundColor = [PTKColor almostWhiteColor];
        cell.showLastSeen = YES;
        cell.isOnline = (contact.user.userId && [_onlineDataSource isUserOnline:contact.user.userId]);
        cell.accessory = PTKContactCellAccessoryCrown;
        cell.tintColor = _roomColor;

        [cell setContact:contact];
        cell.onlineRoomId = [_onlineDataSource roomIdForUser:contact.user.userId];

        return cell;
    }
    else if (indexPath.section == PTKAddModeratorSectionMembers) {
        PTKContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellMember"];
        if (!cell) {
            cell = [[PTKContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellMember"];
        }
        
        PTKUser *member = _filteredMembers[indexPath.row];
        PTKContact *contact = [[PTKContact alloc] initWithUser:member];
        
        cell.backgroundColor = [PTKColor almostWhiteColor];
        cell.showLastSeen = YES;
        cell.isOnline = (contact.user.userId && [_onlineDataSource isUserOnline:contact.user.userId]);
        cell.accessory = PTKContactCellAccessoryCrown;
        cell.tintColor = [PTKColor grayColor];

        [cell setContact:contact];
        cell.onlineRoomId = [_onlineDataSource roomIdForUser:contact.user.userId];

        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL hadModerators = _moderators.count > 0;
    
    if (indexPath.section == PTKAddModeratorSectionModerators) {
        PTKUser *user = _filteredModerators[indexPath.row];
        
        [_moderators removeObject:user];
        [_members addObject:user];
        
        [self loadModeratorsAndMembers];
    }
    else if (indexPath.section == PTKAddModeratorSectionMembers) {
        PTKUser *user = _filteredMembers[indexPath.row];
        
        [_members removeObject:user];
        [_moderators addObject:user];
        
        [self loadModeratorsAndMembers];
    }
    
    BOOL hasModerators = _moderators.count > 0;
    if (hasModerators != hadModerators && hasModerators) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:localizedString(@"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction:)];
        cancelButton.tintColor = _roomColor;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:localizedString(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(doneAction:)];
        doneButton.tintColor = _roomColor;
        
        _customNavBar.topItem.leftBarButtonItem = cancelButton;
        _customNavBar.topItem.rightBarButtonItem = doneButton;
    }
    else if (hasModerators != hadModerators) {
        UIImage *backImage = [PTKGraphics navigationBackImageWithColor:nil];
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(dismissAction:)];
        closeButton.tintColor = _roomColor;
        _customNavBar.topItem.leftBarButtonItem = closeButton;
        _customNavBar.topItem.rightBarButtonItem = nil;
    }
}

#pragma mark - PTKAPICallback methods

- (void)onDidAddModerator:(PTKAPIResponse *)response {
    PTKUser *user = response.userInfo[kKeyUser];
    [_addingModerators removeObject:user];
    
    if (response.error) {
        [self hideSpinner];
        
        if ([response.error isError:PTKErrorCodeNoPermissions]) {
            PTKAlertController *alertView = [PTKAlertController alertControllerWithTitle:localizedString(@"You can't do that!") message:localizedString(@"Only moderators can add other moderators")];
            [alertView addButtonWithTitle:localizedString(@"OK") block:^(){
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [self presentViewController:alertView animated:YES completion:nil];
            
            _cancelAddModerators = YES;
            
            [_addingModerators removeAllObjects];
            
        }
        
        return;
    }
    else {
        [_moderatorDataSource sortAndAddObject:user completion:nil];
    }
    
    if (_addingModerators.count <= 0 && !_cancelAddModerators) {
        [self hideSpinner];
        
        if (self.isLeaving) {
            PTKRoom *room = [[PTKWeakSharingManager roomsDataSource] objectWithId:_roomId];
            
            PTKAlertController *alertController = [PTKAlertController alertControllerWithTitle:localizedString(@"Still leaving?") message:[NSString stringWithFormat:localizedString(@"Great, you've appointed a new moderator. Still want to leave %@?"), room.roomDisplayName]];
            
            [alertController addButtonWithTitle:localizedString(@"No") block:^(){
                [self.roomNavigationController enterRoom:_roomId withMessage:nil source:PTKRoomSourceTypeRoom animated:YES completion:nil];
            }];
            
            [alertController addButtonWithTitle:localizedString(@"Yes") block:^(){
                [[PTKWeakSharingManager roomsDataSource] removeRoomWithId:_roomId completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - PTKPaginatedDataSourceDelegate methods

- (void)resetStateFromDataSource:(PTKPaginatedDataSource *)dataSource {
    [self loadModeratorsAndMembers];
}

- (void)paginatedDataSourceDidLoad:(PTKPaginatedDataSource *)dataSource {
    [self resetStateFromDataSource:dataSource];
}

- (void)paginatedDataSource:(PTKPaginatedDataSource *)dataSource didDeleteItemAtIndex:(NSUInteger)index {
    [self resetStateFromDataSource:dataSource];
}

- (void)paginatedDataSource:(PTKPaginatedDataSource *)dataSource didMoveItemFromIndex:(NSUInteger)oldIndex toIndex:(NSUInteger)newIndex {
    [self resetStateFromDataSource:dataSource];
}

- (void)paginatedDataSource:(PTKPaginatedDataSource *)dataSource didUpdateItemAtIndex:(NSUInteger)index {
    [self resetStateFromDataSource:dataSource];
}

- (void)paginatedDataSource:(PTKPaginatedDataSource *)dataSource didInsertItemAtIndex:(NSUInteger)index {
    [self resetStateFromDataSource:dataSource];
}

#pragma mark - PTKOnlinePresenceDataSourceDelegate methods

- (void)onlinePresenceDataSourceDidChange:(PTKOnlinePresenceDataSource *)dataSource {
    if (dataSource == _onlineDataSource) {
        [_tableView reloadData];
    }
}

@end
