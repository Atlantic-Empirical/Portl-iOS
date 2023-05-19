//
//  PTKAccountSettingsViewController.m
//  portkey
//
//  Created by Daniel Amitay on 4/29/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "Analytics.h"
#import "PTKAccountSettingsViewController.h"
#import "PTKPhoneChangeViewController.h"
#import "PTKEditableAvatarView.h"
#import "PTKPermissionViewController.h"
#import "PTKS3Uploader.h"
#import "PTKSession.h"
#import "PTKWebViewController.h"
#import "PTKPhoneUtility.h"
#import "RMPhoneFormat.h"
#import "TTTAttributedLabel.h"
#import "PTKNetworkActivityIndicator.h"
#import "PTKTimer.h"

typedef enum {
    PTKAccountSettingsSectionProfile,
    PTKAccountSettingsSectionNotifications,
    PTKAccountSettingsSectionOther,
    PTKAccountSettingsSectionCount
} PTKAccountSettingsSection;

@interface PTKAccountSettingsViewController () <MFMailComposeViewControllerDelegate, PTKEditableAvatarViewDelegate, UITextFieldDelegate, TTTAttributedLabelDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate, UIPopoverPresentationControllerDelegate> {
    UIView *_backgroundView, *_contentView;
    UITextField *_userNameTextField;
    UIButton *_cancelNameButton;
    TTTAttributedLabel *_footerLabel;
    UIButton *_contactButton;
    BOOL _isUpdatingUserName;
    BOOL _isWaitingToClose;
    BOOL _isEditingName;

    UISwitch *_muteSwitch, *_altHeaderSwitch, *_dataUsageSwitch;
    NSTimeInterval _muteInterval;
    PTKTimer *_muteTimer;
    UILabel* _autoVideoDetailLabel;
}

@end

@implementation PTKAccountSettingsViewController

#pragma mark - Lifecycle methods

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;

    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;

    return self;
}

- (void)dealloc {
    _userNameTextField.delegate = nil;
}


#pragma mark - View methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Profile";
    self.view.backgroundColor = [UIColor clearColor];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", 0) style:UIBarButtonItemStyleDone target:self action:@selector(dismissAction:)];

    _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.alpha = 1.0f;
    [self.view addSubview:_backgroundView];

    _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _contentView.backgroundColor = [PTKColor whiteColor];
    _contentView.clipsToBounds = YES;
    [self.view addSubview:_contentView];

    [_contentView addSubview:self.tableView];

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, 146.0f)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    headerView.backgroundColor = [PTKColor blueColor];
    [_contentView addSubview:headerView];

    PTKEditableAvatarView *editableAvatarView = [[PTKEditableAvatarView alloc] initWithFrame:CGRectMake((headerView.width - 100.0f) / 2.0f, 23.0f, 100.0f, 100.0f)];
    editableAvatarView.delegate = self;
    editableAvatarView.tintColor = [PTKColor blueColor];
    [headerView addSubview:editableAvatarView];

    UIEdgeInsets insets = self.tableView.contentInset;
    insets.top = headerView.height - 10.0f;
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    self.tableView.backgroundColor = [UIColor whiteColor];

    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 160.0f)];
    tableFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5.0f, tableFooterView.width, 50.0f)];
    title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [PTKFont boldFontOfSize:13.0f];
    title.text = NSLocalizedString(@"QUESTIONS + SUGGESTIONS", 0);
    title.backgroundColor = [UIColor whiteColor];
    [tableFooterView addSubview:title];

    _contactButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _contactButton.frame = CGRectMake(20.0f, 55.0f, tableFooterView.width - 40.0f, 40.0f);
    _contactButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _contactButton.layer.cornerRadius = 20.0f;
    _contactButton.backgroundColor = [UIColor clearColor];
    _contactButton.titleLabel.font = [PTKFont boldFontOfSize:17.0f];
    _contactButton.tintColor = [PTKColor blueColor];
    _contactButton.layer.borderWidth = 1.5f;
    _contactButton.layer.borderColor = [PTKColor blueColor].CGColor;
    [_contactButton setTitle:NSLocalizedString(@"Contact Us",0) forState:UIControlStateNormal];
    [_contactButton addTarget:self action:@selector(contactUsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:_contactButton];

#if PORTKEY_STAGE || PORTKEY_DEV
    _contactButton.frame = CGRectMake(20.0f, 55.0f, (tableFooterView.width / 2.0f) - 30.0f, 40.0f);

    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeSystem];
    logoutButton.frame = CGRectMake((tableFooterView.width / 2.0f) + 10.0f, 55.0f, (tableFooterView.width / 2.0f) - 30.0f, 40.0f);
    logoutButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    logoutButton.layer.cornerRadius = 20.0f;
    logoutButton.backgroundColor = [UIColor clearColor];
    logoutButton.titleLabel.font = [PTKFont boldFontOfSize:17.0f];
    logoutButton.tintColor = [PTKColor redColor];
    logoutButton.layer.borderWidth = 1.5f;
    logoutButton.layer.borderColor = [PTKColor redColor].CGColor;
    [logoutButton setTitle:NSLocalizedString(@"Log Out",0) forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:logoutButton];
#endif

    _footerLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, tableFooterView.height - 55.0f, tableFooterView.width, 15.0f)];
    _footerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _footerLabel.textAlignment = NSTextAlignmentCenter;
    _footerLabel.textColor = [UIColor lightGrayColor];
    _footerLabel.font = [PTKFont boldFontOfSize:13.0f];
    _footerLabel.text = NSLocalizedString(@"Terms of Service • Privacy Policy",0);
    _footerLabel.linkAttributes = @{NSFontAttributeName: _footerLabel.font, (NSString *)kCTForegroundColorAttributeName: [UIColor lightGrayColor], NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};;
    _footerLabel.inactiveLinkAttributes = @{NSFontAttributeName: _footerLabel.font, (NSString *)kCTForegroundColorAttributeName: [UIColor lightGrayColor], NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    _footerLabel.activeLinkAttributes = @{NSFontAttributeName: _footerLabel.font, (NSString *)kCTForegroundColorAttributeName: [UIColor darkGrayColor], NSUnderlineStyleAttributeName: @(NSUnderlineStyleNone)};
    _footerLabel.delegate = self;
    [_footerLabel addLinkToURL:[NSURL URLWithString:@"https://signal.is/terms"] withRange:NSMakeRange(0, 16)];
    [_footerLabel addLinkToURL:[NSURL URLWithString:@"https://signal.is/privacy"] withRange:NSMakeRange(19, 14)];
    _footerLabel.backgroundColor = [UIColor whiteColor];
    [tableFooterView addSubview:_footerLabel];

    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tableFooterView.height - 33.0f, tableFooterView.width, 15.0f)];
    versionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor lightGrayColor];
    versionLabel.font = [PTKFont regularFontOfSize:13.0f];
    versionLabel.text = [NSString stringWithFormat:@"v%@", getAppVersion()];
    versionLabel.backgroundColor = [UIColor whiteColor];
    [tableFooterView addSubview:versionLabel];

    self.tableView.tableFooterView = tableFooterView;

    _userNameTextField = [[UITextField alloc] init];
    _userNameTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _userNameTextField.textColor = [PTKColor blueColor];
    _userNameTextField.font = [PTKFont regularFontOfSize:17.0f];
    _userNameTextField.text = [[PTKAppState sharedInstance] getUserDisplayName];
    _userNameTextField.textAlignment = NSTextAlignmentCenter;
    _userNameTextField.userInteractionEnabled = NO;
    _userNameTextField.delegate = self;
    _userNameTextField.returnKeyType = UIReturnKeyDone;
    _userNameTextField.enablesReturnKeyAutomatically = YES;
    _userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;

    _cancelNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelNameButton.titleLabel.font = [PTKFont regularFontOfSize:14.0f];
    [_cancelNameButton setTitleColor:[PTKColor blueColor] forState:UIControlStateNormal];
    _cancelNameButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_cancelNameButton setTitle:NSLocalizedString(@"Cancel",0) forState:UIControlStateNormal];
    _cancelNameButton.alpha = 0.0f;
    _cancelNameButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_cancelNameButton addTarget:self action:@selector(cancelNameButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    _muteSwitch = [[UISwitch alloc] init];
    _muteSwitch.onTintColor = [PTKColor blueColor];
    [_muteSwitch addTarget:self action:@selector(muteSwitchDidChange:) forControlEvents:UIControlEventValueChanged];

    _altHeaderSwitch = [[UISwitch alloc] init];
    _altHeaderSwitch.onTintColor = [PTKColor blueColor];
    [_altHeaderSwitch addTarget:self action:@selector(altHeaderSwitchDidChange:) forControlEvents:UIControlEventValueChanged];
    _altHeaderSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"sp_altHeader"];

    _dataUsageSwitch = [[UISwitch alloc] init];
    _dataUsageSwitch.onTintColor = [PTKColor blueColor];
    [_dataUsageSwitch addTarget:self action:@selector(dataUsageSwitchDidChange:) forControlEvents:UIControlEventValueChanged];
    _dataUsageSwitch.on = [PTKUserDefaults dataSavingMode];

    // Fire off event for settings opened
    [PTKEventTracker track:PTKEventTypeSettingsLoaded];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGFloat size = MAX(160.0f, _contentView.height - self.tableView.contentSize.height - 20.0f);
    [self.tableView.tableFooterView setSize:CGSizeMake(self.tableView.width, size)];

    self.tableView.frame = (CGRect) {
        .size = _contentView.frame.size
    };

    PTKAPICallback *callback = [PTKAPI callbackWithTarget:self selector:@selector(onDidFetchMe:)];
    [PTKAPI fetchUserWithCallback:callback];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Account"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


#pragma mark - View controller preferences

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersNavigationBarHidden {
    return NO;
}


#pragma mark - Transition and Presentation

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* vc1 = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* vc2 = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* con = [transitionContext containerView];
    UIView* v1 = vc1.view;
    UIView* v2 = vc2.view;

    if (vc2 == self) { // Presenting
        [con addSubview:v2];
        v2.frame = v1.frame;

        [UIView animateWithDuration:0.25 animations:^{
            v1.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else if (vc1 == self) { // Dismissing
        [UIView animateWithDuration:0.25 animations:^{
            v2.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}


#pragma mark - Interface element methods

- (void)dismissAction:(id)sender {
    if (_isEditingName) {
        [self updateUserName];
        [_userNameTextField resignFirstResponder];
        _isEditingName = NO;
        return;
    }

    if ([self.delegate respondsToSelector:@selector(accountSettingsDidClose:)]) {
        [self.delegate accountSettingsDidClose:self];
    } else if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showWebViewControllerForURL:(NSURL *)url {
    PTKWebViewController *webViewController = [[PTKWebViewController alloc] initWithURL:url];
    webViewController.autorotateLock = true;
    [self presentViewController:webViewController animated:YES completion:^(){webViewController.autorotateLock = false;}];
}

- (BOOL)updateUserName {
    if (_isUpdatingUserName) {
        return NO;
    }

    NSString *fullName = [_userNameTextField.text parsedFullName];
    NSString *firstName = ([_userNameTextField.text parsedFirstName] ?: @"");
    NSString *lastName = ([_userNameTextField.text parsedLastName] ?: @"");
    if (fullName.length < 3) {
        // User must provide a name greater than 3 charactsers
        [self showAlertWithTitle:NSLocalizedString(@"Name",0) andMessage:NSLocalizedString(@"Your name is not long enough",0)];
        return NO;
    } else if (firstName.length > 20) {
        // User must provide a first name lesser than 20 characters
        [self showAlertWithTitle:NSLocalizedString(@"Name",0) andMessage:NSLocalizedString(@"Your first name cannot be longer than 20 characters",0)];
        return NO;
    } else if (lastName.length > 20) {
        // User must provide a last name lesser than 20 characters
        [self showAlertWithTitle:NSLocalizedString(@"Name",0) andMessage:NSLocalizedString(@"Your last name cannot be longer than 20 characters",0)];
        return NO;
    }

    if ([fullName isEqualToString:[[PTKAppState sharedInstance] getUserDisplayName]]) {
        // New name is exactly the same, skip updating
        if (_isWaitingToClose) {
            [self dismissAction:nil];
        }
        return NO;
    }

    _isUpdatingUserName = YES;
    [PTKNetworkActivityIndicator ref];

    NSDictionary *params = @{@"firstName": firstName, @"lastName": lastName};
    PTKAPICallback *callback = [PTKAPI callbackWithTarget:self selector:@selector(onDidUpdateUserProperties:)];
    [PTKAPI updateUserProperties:params callback:callback];

    // Update tracking properties when modifying the user
    [PTKEventTracker updateServerProperties];
    [PTKEventTracker track:PTKEventTypeUserFullnameSet withProperties:@{@"characterCount": @(fullName.length)}];

    return YES;
}

- (void)muteSwitchDidChange:(UISwitch *)sender {
    [PTKNetworkActivityIndicator ref];
    PTKAPICallback *callback = [PTKAPI callbackWithTarget:self selector:@selector(onDidUpdateMute:)];

    if (sender.on) {
        [PTKEventTracker track:PTKEventTypeGlobalMuteOn];
        
        PTKActionSheetController *actionSheetController = [PTKActionSheetController actionSheetControllerWithTitle:nil message:NSLocalizedString(@"Mute Signal",0)];
        [actionSheetController addButtonWithTitle:NSLocalizedString(@"1 hour",0) block:^{
            
            [PTKAPI muteForDuration:(sender.on ? (60 * 60) : 0) callback:callback];
        }];
        [actionSheetController addButtonWithTitle:NSLocalizedString(@"8 hours",0) block:^{
            
            [PTKAPI muteForDuration:(sender.on ? (8*(60 * 60)) : 0) callback:callback];
        }];
        [actionSheetController addButtonWithTitle:NSLocalizedString(@"1 day",0) block:^{
            
            [PTKAPI muteForDuration:(sender.on ? (24*(60 * 60)) : 0) callback:callback];
        }];
        [actionSheetController addButtonWithTitle:NSLocalizedString(@"1 week",0) block:^{
            
            [PTKAPI muteForDuration:(sender.on ? ((24 * 7)*(60 * 60)) : 0) callback:callback];
        }];
        [actionSheetController addCancelButtonWithTitle:NSLocalizedString(@"Cancel", 0) block:^{
            [sender setOn:NO animated:YES];
        }];
        [self presentViewController:actionSheetController animated:YES completion:nil];
    } else {
        [PTKAPI muteForDuration:0 callback:callback];
    }
}

- (void)altHeaderSwitchDidChange:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_altHeaderSwitch.on forKey:@"sp_altHeader"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dataUsageSwitchDidChange:(UISwitch *)sender {
    [PTKUserDefaults setValue:@(_dataUsageSwitch.on) forKey:PTKUserDefaultsSessionKeyDataSavingMode];

    if (_dataUsageSwitch.on) {
        [PTKUserDefaults setValue:kKeyAutoPlayNone forKey:PTKUserDefaultsAutoVideoLoadOption synchronize:YES];
        _autoVideoDetailLabel.text = NSLocalizedString(@"Disabled",0);
    }
}

- (void)contactUsButtonAction:(id)sender {
    PTKAlertController *alert = [PTKAlertController alertControllerWithTitle:@"Include Signal Logs?" message:@"Do you want to include Signal logs in your message? If you are reporting an issue this could help us investigate it."];

    [alert addButtonWithTitle:@"Yes" block:^{
        [self presentMailComposerAndIncludeLogs:YES];
    }];

    [alert addButtonWithTitle:@"No" block:^{
        [self presentMailComposerAndIncludeLogs:NO];
    }];
}

- (void)presentMailComposerAndIncludeLogs:(BOOL)includeLogs {
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    if (!mailComposeViewController) {
        return;
    }

    mailComposeViewController.mailComposeDelegate = self;

#if PORTKEY_STAGE
    [mailComposeViewController setToRecipients:@[@"ios@signal.is"]];
    [mailComposeViewController setSubject:@"Feedback for Signal - Stage"];
#else
    [mailComposeViewController setToRecipients:@[@"contact@signal.is"]];
    [mailComposeViewController setSubject:@"Feedback for Signal"];
#endif

    NSMutableString *prepopulatedMessageBody = [[NSMutableString alloc] init];
    [prepopulatedMessageBody appendFormat:@"\n\n\n------------- Diagnostic Info -------------\n"];
    [prepopulatedMessageBody appendFormat:@"Name: %@\n", [[PTKAppState sharedInstance] getUserDisplayName]];
    [prepopulatedMessageBody appendFormat:@"User ID: %@\n", [[PTKAppState sharedInstance] getUserId]];
    [prepopulatedMessageBody appendFormat:@"Device: %@\n", [[UIDevice currentDevice] model]];
    [prepopulatedMessageBody appendFormat:@"OS: %@\n", [[UIDevice currentDevice] systemVersion]];
    [prepopulatedMessageBody appendFormat:@"Signal version: %@\n", getAppVersion()];
    [mailComposeViewController setMessageBody:prepopulatedMessageBody isHTML:NO];

    if (includeLogs) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *storagePath = [[paths firstObject] stringByAppendingPathComponent:@"PTKLog"];
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:storagePath error:NULL];

        for (NSString *file in files) {
            if ([[file pathExtension] isEqualToString:@"log"]) {
                NSString *filePath = [storagePath stringByAppendingPathComponent:file];
                NSData *data = [NSData dataWithContentsOfFile:filePath];
                [mailComposeViewController addAttachmentData:data mimeType:@"text/plain" fileName:file];
            }
        }
    }

    [self presentViewController:mailComposeViewController animated:YES completion:nil];
}

- (void)muteTimerDidUpdate {
    _muteInterval -= 1.0f;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:PTKAccountSettingsSectionNotifications]];
    cell.textLabel.text = [self muteSwitchLabelText];
}

- (void)logoutButtonTapped {
    PTKActionSheetController *actionSheetController = [PTKActionSheetController actionSheetControllerWithTitle:nil message:NSLocalizedString(@"Are you sure you wish to log out?",0)];
    [actionSheetController addDestructiveButtonWithTitle:NSLocalizedString(@"Log Out",0) block:^{
        [[PTKAppState sharedInstance] logout];
    }];
    [actionSheetController addCancelButtonWithTitle:NSLocalizedString(@"Cancel", 0)];
    [self presentViewController:actionSheetController animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return PTKAccountSettingsSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int otherCount = 2;
    if (EXPERIMENTAL) {
        otherCount += 1;
    }

    switch (section) {
        case PTKAccountSettingsSectionProfile: return 2;
        case PTKAccountSettingsSectionNotifications: return 1;
        case PTKAccountSettingsSectionOther: return otherCount;
        default: return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case PTKAccountSettingsSectionNotifications:
        case PTKAccountSettingsSectionOther:
            return 40.0f;
        default:
            return 10.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case PTKAccountSettingsSectionProfile: return 70.0f;
        case PTKAccountSettingsSectionNotifications: return 50.0f;
        case PTKAccountSettingsSectionOther: return 50.0f;
        default: return 0.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case PTKAccountSettingsSectionNotifications: {
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40.0f)];
            header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40.0f)];
            title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            title.textAlignment = NSTextAlignmentCenter;
            title.font = [PTKFont boldFontOfSize:19.0f];
            title.text = NSLocalizedString(@"Signal Settings", 0);
            title.backgroundColor = [UIColor whiteColor];
            [header addSubview:title];
            return header;
        }
        case PTKAccountSettingsSectionOther: {
            UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40.0f)];
            header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40.0f)];
            title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            title.textAlignment = NSTextAlignmentCenter;
            title.font = [PTKFont boldFontOfSize:13.0f];
            title.text = NSLocalizedString(@"OTHER SETTINGS", 0);
            title.backgroundColor = [UIColor whiteColor];
            [header addSubview:title];
            return header;
        }
        default: {
            return nil;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;

    if (indexPath.section == 2 && indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AutoVideoCell"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"AutoVideoCell"];
    } else {
        [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    cell.preservesSuperviewLayoutMargins = NO;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.textLabel.font = [PTKFont regularFontOfSize:17.0f];
    cell.textLabel.textColor = [PTKColor blueColor];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.accessoryView = nil;

    switch (indexPath.section) {
        case PTKAccountSettingsSectionProfile: {
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = nil;
                    [cell.contentView addSubview:_userNameTextField];
                    _userNameTextField.frame = CGRectInset(cell.contentView.bounds, 20.0f, 0.0f);

                    [cell.contentView addSubview:_cancelNameButton];
                    _cancelNameButton.frame = (CGRect) {
                        .origin.x = cell.contentView.bounds.size.width - 80.0f,
                        .origin.y = 0.0f,
                        .size.width = 80.0f,
                        .size.height = cell.contentView.height
                    };
                }   break;
                case 1: {
                    NSString *phoneNumber = [PTKData sharedInstance].session.phoneNumber;
                    NSString *sanitizedPhoneNumber = [PTKPhoneUtility sanitizePhoneNumber:phoneNumber];
                    NSString *phoneFormatted = [[RMPhoneFormat instance] format:sanitizedPhoneNumber];
                    if (phoneFormatted) {
                        sanitizedPhoneNumber = phoneFormatted;
                    }
                    cell.textLabel.text = sanitizedPhoneNumber;
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }   break;
                default:
                    break;
            }
        }   break;
        case PTKAccountSettingsSectionNotifications: {
            cell.textLabel.text = [self muteSwitchLabelText];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = _muteSwitch;
        }   break;
        case PTKAccountSettingsSectionOther: {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"Use Less Data", 0);
                    cell.textLabel.textColor = [UIColor blackColor];
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryView = _dataUsageSwitch;
                    break;
                case 1:
                    cell.textLabel.text = @"Auto-Play Videos";
                    cell.textLabel.textColor = [UIColor blackColor];

                    if ([[PTKUserDefaults stringForKey:PTKUserDefaultsAutoVideoLoadOption defaultTo:isLowPowerDevice() ? kKeyAutoPlayNone : kKeyAutoPlayCellular]
                         isEqualToString:kKeyAutoPlayCellular]) {
                        cell.detailTextLabel.text = NSLocalizedString(@"WiFi & Cellular",0);
                    } else if ([[PTKUserDefaults stringForKey:PTKUserDefaultsAutoVideoLoadOption defaultTo:@""]
                                isEqualToString:kKeyAutoPlayWifi]) {
                        cell.detailTextLabel.text = NSLocalizedString(@"WiFi Only",0);
                    } else {
                        cell.detailTextLabel.text = NSLocalizedString(@"Disabled",0);
                    }
                    _autoVideoDetailLabel = cell.detailTextLabel;

                    cell.detailTextLabel.textColor = [PTKColor blueActionColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    break;
                case 2:
                    cell.textLabel.text = @"Alt Header Behavior";
                    cell.textLabel.textColor = [UIColor blackColor];
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryView = _altHeaderSwitch;
                    break;
                default:
                    break;
            }
        }   break;
        default:
            break;
    }
    return cell;
}

- (NSString *)muteSwitchLabelText {
    if (_muteInterval > 0) {
        _muteSwitch.on = YES;
        return [NSString stringWithFormat:@"  %@ %@", NSLocalizedString(@"Muted for", 0), [PTKDatetimeUtility formattedTimeInterval:_muteInterval]];
    } else {
        _muteSwitch.on = NO;
        return NSLocalizedString(@"Mute Notifications", 0);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.section) {
        case PTKAccountSettingsSectionProfile: {
            switch (indexPath.row) {
                case 0:
                    _userNameTextField.userInteractionEnabled = YES;
                    [_userNameTextField becomeFirstResponder];
                    break;
                case 1:
                    [self launchPhoneNumberSwitcher];
                    break;
                default:
                    break;
            }
        }   break;
        case PTKAccountSettingsSectionNotifications: {
            switch (indexPath.row) {
                case 1:
                    [self askForVideoAutoPlaySettings];
                    break;
                default:
                    break;
            }
            break;
        }
        case PTKAccountSettingsSectionOther: {
            switch (indexPath.row) {
                case 0:
                    break;
                case 1:
                    [self askForVideoAutoPlaySettings];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

- (void)askForVideoAutoPlaySettings {
    PTKActionSheetController *actionSheetController = [PTKActionSheetController actionSheetControllerWithTitle:nil message:NSLocalizedString(@"Auto Play Videos",0)];
    [actionSheetController addButtonWithTitle:NSLocalizedString(@"WiFi Only",0) block:^{
        [PTKUserDefaults setValue:kKeyAutoPlayWifi forKey:PTKUserDefaultsAutoVideoLoadOption synchronize:YES];
        _autoVideoDetailLabel.text = NSLocalizedString(@"WiFi Only",0);
    }];
    [actionSheetController addButtonWithTitle:NSLocalizedString(@"WiFi & Cellular",0) block:^{
        [PTKUserDefaults setValue:kKeyAutoPlayCellular forKey:PTKUserDefaultsAutoVideoLoadOption synchronize:YES];
        _autoVideoDetailLabel.text = NSLocalizedString(@"WiFi & Cellular",0);
    }];
    [actionSheetController addDestructiveButtonWithTitle:NSLocalizedString(@"Disable",0) block:^{
        [PTKUserDefaults setValue:kKeyAutoPlayNone forKey:PTKUserDefaultsAutoVideoLoadOption synchronize:YES];
        _autoVideoDetailLabel.text = NSLocalizedString(@"Disabled",0);
    }];
    [actionSheetController addCancelButtonWithTitle:NSLocalizedString(@"Cancel", 0) block:nil];
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

- (void)launchPhoneNumberSwitcher {
    PTKPhoneChangeViewController* phone = [[PTKPhoneChangeViewController alloc] init];
    PTKNavigationController* nav = [[PTKNavigationController alloc] initWithRootViewController:phone];
    nav.lockedIntoPortrait = YES;
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - MFMailComposeViewControllerDelegate delegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - PTKEditableAvatarViewDelegate methods

- (void)editableAvatarView:(PTKEditableAvatarView *)view wantsPopupForPermission:(PTKPermissionType)permission {
    PTKPermissionViewController *permissionViewController = [[PTKPermissionViewController alloc] initWithPermissionType:permission];
    [self presentViewController:permissionViewController animated:YES completion:nil];
}

- (void)editableAvatarViewWasTapped:(PTKEditableAvatarView *)view {
    [view showActionSheetInViewController:self];
}

- (void)editableAvatarViewWasChanged:(PTKEditableAvatarView *)view sourceType:(UIImagePickerControllerSourceType)sourceType previousImage:(UIImage *)previous {
    [[PTKS3Uploader sharedInstance] uploadUserAvatar:view.image];
}


#pragma mark - UITextFieldDelegate methods

- (void)animateTextFieldAlignmentTo:(NSTextAlignment)textAlignment {
    CGPoint originalTextFieldCenter = _userNameTextField.center;
    UIView *superview = _userNameTextField.superview;

    [_userNameTextField sizeToFit];

    CGPoint startingCenter = CGPointZero;
    CGPoint endingCenter = CGPointZero;
    CGFloat cancelAlpha = 0.0f;
    CGRect finalTextFieldFrame = _userNameTextField.frame;
    if (textAlignment == NSTextAlignmentCenter) {
        startingCenter = (CGPoint) {
            .x = 20.0f + (_userNameTextField.bounds.size.width / 2.0f),
            .y = originalTextFieldCenter.y
        };
        endingCenter = (CGPoint) {
            .x = (superview.bounds.size.width / 2.0f),
            .y = originalTextFieldCenter.y
        };
        cancelAlpha = 0.0f;
        finalTextFieldFrame = CGRectInset(superview.bounds, 20.0f, 0.0f);
    } else if (textAlignment == NSTextAlignmentLeft) {
        startingCenter = (CGPoint) {
            .x = (superview.bounds.size.width / 2.0f),
            .y = originalTextFieldCenter.y
        };
        endingCenter = (CGPoint) {
            .x = 20.0f + (_userNameTextField.bounds.size.width / 2.0f),
            .y = originalTextFieldCenter.y
        };
        cancelAlpha = 1.0f;
        finalTextFieldFrame = UIEdgeInsetsInsetRect(superview.bounds, (UIEdgeInsets) {
            .left = 20.0f,
            .right = 70.0f
        });
    }

    _userNameTextField.center = startingCenter;

    [UIView animateWithDuration:0.4f
                     animations:^{
                         _userNameTextField.center = endingCenter;
                         _cancelNameButton.alpha = cancelAlpha;
                     } completion:^(BOOL finished) {
                         _userNameTextField.textAlignment = textAlignment;
                         _userNameTextField.frame = finalTextFieldFrame;
                     }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _userNameTextField) {
        [self animateTextFieldAlignmentTo:NSTextAlignmentLeft];
        _isEditingName = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _userNameTextField) {
        _isEditingName = NO;
        _userNameTextField.userInteractionEnabled = NO;
        [self animateTextFieldAlignmentTo:NSTextAlignmentCenter];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _userNameTextField) {
        [self updateUserName];
        [textField resignFirstResponder];
    }

    return YES;
}

- (void)cancelNameButtonPressed {
    _userNameTextField.text = [[PTKAppState sharedInstance] getUserDisplayName];
    [_userNameTextField resignFirstResponder];
}


#pragma mark - TTTAtributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    PTKWebViewController *webViewController = [[PTKWebViewController alloc] initWithURL:url];
    webViewController.autorotateLock = true;
    [self presentViewController:webViewController animated:YES completion:^(){webViewController.autorotateLock = false;}];
}


#pragma mark - PTKAPICallback methods

- (void)onDidUpdateUserProperties:(PTKAPIResponse *)response {
    [PTKNetworkActivityIndicator unref];
    _isUpdatingUserName = NO;

    if (response.error) {
        [self showAlertWithTitle:NSLocalizedString(@"Error", 0) andMessage:response.error.localizedDescription];
        return;
    }

    [PTKData sharedInstance].session = [[PTKSession alloc] initWithJSON:response.JSON];
    _userNameTextField.text = [[PTKAppState sharedInstance] getUserDisplayName];
    if (_isWaitingToClose) [self dismissAction:nil];
}

- (void)onDidUpdateMute:(PTKAPIResponse *)response {
    [PTKNetworkActivityIndicator unref];
    if (response.error) {
        [self showAlertWithTitle:NSLocalizedString(@"Error", 0) andMessage:response.error.localizedDescription];
        return;
    }

    NSTimeInterval muteDuration = [response.JSON[@"duration"] doubleValue];
    [PTKData sharedInstance].session.muteDuration = muteDuration / 1000.0;

    _muteInterval = [PTKData sharedInstance].session.muteDuration;
    if (_muteInterval > 0 && !_muteTimer) {
        _muteTimer = [[PTKTimer alloc] initRepeatingTimerWithTarget:self selector:@selector(muteTimerDidUpdate) initialDelaySeconds:1.0f intervalSeconds:1.0f];
    } else if (_muteInterval == 0) {
        [_muteTimer cancel];
        _muteTimer = nil;
    }

    [self.tableView reloadData];
}

- (void)onDidFetchMe:(PTKAPIResponse *)response {
    if (response.error) {
        // Silently fail
        // TODO: retry?
        return;
    }
    PTKSession *session = [[PTKSession alloc] initWithJSON:response.JSON];
    if (session) {
        [PTKData sharedInstance].session = session;

        _muteInterval = [PTKData sharedInstance].session.muteDuration;
        if (_muteInterval > 0 && !_muteTimer) {
            _muteTimer = [[PTKTimer alloc] initRepeatingTimerWithTarget:self selector:@selector(muteTimerDidUpdate) initialDelaySeconds:1.0f intervalSeconds:1.0f];
        } else if (_muteInterval == 0) {
            [_muteTimer cancel];
            _muteTimer = nil;
        }
    }
    [self.tableView reloadData];
}

@end
