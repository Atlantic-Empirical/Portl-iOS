//
//  PTKAppSettingsViewController.m
//  portkey
//
//  Created by Adam Bellard on 2/2/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKAppSettingsViewController.h"
#import "PTKWebViewController.h"
#import "SVWebViewController.h"
#import "PTKPhoneUtility.h"
#import "PTKEmailPickerViewController.h"
#import "PTKPhoneChangeViewController.h"
#import "PTKPairedAccountSettingsViewController.h"
#import "PTKDataUsageSettingsViewController.h"
#import "PTKPrivacysettingsViewController.h"
#import "PTKNotificationSettingsViewController.h"
#import "PTKEditableAvatarView.h"
#import "PTKPermissionViewController.h"
#import "PTKS3Uploader.h"
#import "PTKSettingsTableViewCell.h"

//#import <StoreKit/SKStoreReviewController.h>

typedef NS_ENUM(NSUInteger, PTKAppSettingsSection) {
    PTKAppSettingsSectionAvatar,
    PTKAppSettingsSectionProfileDetails,
    PTKAppSettingsSectionAccountDetails,
    PTKAppSettingsSectionAppSettings,
    PTKAppSettingsSectionSupport,
    PTKAppSettingsSectionAbout,
    PTKAppSettingsSectionLogOutDelete,
    PTKAppSettingsSectionRate,
    PTKAppSettingsSectionCount,
};

typedef NS_ENUM(NSUInteger, PTKAppSettingsAvatarRow) {
    PTKAppSettingsAvatarRowMain,
    PTKAppSettingsAvatarRowCount,
};

typedef NS_ENUM(NSUInteger, PTKAppSettingsProfileDetailsRow) {
    PTKAppSettingsProfileDetailsRowName = 10,
    PTKAppSettingsProfileDetailsRowUsername,
    PTKAppSettingsProfileDetailsRowPrivacy,
    PTKAppSettingsProfileDetailsRowCount,
};

typedef NS_ENUM(NSUInteger, PTKAppSettingsAccountDetailsRow) {
    PTKAppSettingsAccountDetailsRowPhone = 20,
    PTKAppSettingsAccountDetailsRowEmail,
//    PTKAppSettingsAccountDetailsRowPassword,
    PTKAppSettingsAccountDetailsRowPairedAccounts,
    PTKAppSettingsAccountDetailsRowCount,
};

typedef NS_ENUM(NSUInteger, PTKAppSettingsAppSettingsRow) {
    PTKAppSettingsAppSettingsRowNotifications = 30,
    PTKAppSettingsAppSettingsRowDataUsage,
    PTKAppSettingsAppSettingsRowCount,
};

typedef NS_ENUM(NSUInteger, PTKAppSettingsSupportRow) {
    PTKAppSettingsSupportRowHelpCenter = 40,
    PTKAppSettingsSupportRowContactUs,
    PTKAppSettingsSupportRowCount,
};

typedef NS_ENUM(NSUInteger, PTKAppSettingsAboutRow) {
    PTKAppSettingsAboutRowTerms = 50,
    PTKAppSettingsAboutRowLicenses,
    PTKAppSettingsAboutRowCount,
};

typedef NS_ENUM(NSUInteger, PTKAppSettingsLogOutDeleteRow) {
    PTKAppSettingsLogOutDeleteRowDelete = 60,
    PTKAppSettingsLogOutDeleteRowLogOut,
    PTKAppSettingsLogOutDeleteRowAnalyticsToasts,
    PTKAppSettingsLogOutDeleteRowCount,
};

typedef NS_ENUM(NSUInteger, PTKAppSettingsRateRow) {
    PTKAppSettingsRateRowMain = 70,
    PTKAppSettingsRateRowCount,
};

@interface PTKAppSettingsViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MFMailComposeViewControllerDelegate, PTKEditableAvatarViewDelegate> {
    UITableView *_tableView;
    
    PTKEditableAvatarView *_editableAvatarView;
    
    UITextField *_userNameTextField;
    BOOL _isEditingName;
    BOOL _isUpdatingUserName;
    
    PTKImageView *_warningView;
    
    UISwitch *_analyticsToastsSwitch;
    
    UIButton *_doneButton;
}

@end

@implementation PTKAppSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"SETTINGS", 0);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:localizedString(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(userTappedDoneButton)];

    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [PTKColor almostWhiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 40.0f)];
    versionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor lightGrayColor];
    versionLabel.font = [PTKFont regularFontOfSize:13.0f];
    versionLabel.text = [NSString stringWithFormat:localizedString(@"App Version %@"), getAppVersion()];
    _tableView.tableFooterView = versionLabel;
    
    
    // User name text field
    
    _userNameTextField = [[UITextField alloc] init];
    _userNameTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _userNameTextField.textColor = [UIColor darkTextColor];
    _userNameTextField.font = [PTKFont regularFontOfSize:17.0f];
    _userNameTextField.text = [[PTKAppState sharedInstance] getUserDisplayName];
    _userNameTextField.textAlignment = NSTextAlignmentRight;
    _userNameTextField.userInteractionEnabled = NO;
    _userNameTextField.delegate = self;
    _userNameTextField.returnKeyType = UIReturnKeyDone;
    _userNameTextField.enablesReturnKeyAutomatically = YES;
    _userNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    
    _warningView = [[PTKImageView alloc] initWithImage:[[UIImage imageNamed:@"ic_warning"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    _warningView.tintColor = [PTKColor redActionColor];
    _warningView.contentMode = UIViewContentModeScaleAspectFit;
    
    _analyticsToastsSwitch = [[UISwitch alloc] init];
    _analyticsToastsSwitch.on = [PTKUserDefaults boolForKey:PTKUserDefaultsDisplayAnalyticsToasts defaultTo:NO];
    [_analyticsToastsSwitch addTarget:self action:@selector(analyticsToastSwitchDidChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)userTappedDoneButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
    
    // https://airtime.atlassian.net/browse/KEY-3609
    // sometimes the navigation item disappears.  in that case, add a custom done button to the nav bar
    if (self.navigationController.navigationBar.items.count == 0 && _doneButton == nil) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_doneButton setTitle:localizedString(@"Done") forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [PTKFont regularFontOfSize:17.0f];
        [_doneButton addTarget:self action:@selector(userTappedDoneButton) forControlEvents:UIControlEventTouchUpInside];
        [_doneButton sizeToFit];
        _doneButton.center = CGPointMake(self.navigationController.navigationBar.width - _doneButton.width, self.navigationController.navigationBar.height - 22.0f);
        
        [self.navigationController.navigationBar addSubview:_doneButton];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_doneButton) {
        [_doneButton removeFromSuperview];
        _doneButton = nil;
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark UITableViewDataSource and UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == PTKAppSettingsSectionAvatar) {
        return 194.0f;
    }
    if (indexPath.section == PTKAppSettingsSectionRate) {
        return 130.0f;
    }

    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == PTKAppSettingsSectionLogOutDelete) {
        return 24.0f;
    }
    
    if (section == PTKAppSettingsSectionAvatar || section == PTKAppSettingsSectionRate) {
        return 0.0f;
    }
    
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    header.backgroundColor = [PTKColor almostWhiteColor];
    
    [header addBottomSeparatorWithColor:[PTKColor settingsSeparatorColor]];
    
    if (section == PTKAppSettingsSectionLogOutDelete) {
        // no label
        return header;
    }
    
    UILabel *headerText = [[UILabel alloc] init];
    headerText.font = [PTKFont boldFontOfSize:12.0f];
    headerText.textColor = [PTKColor mediumGrayColor];

    NSString *text = @"";
    
    if (section == PTKAppSettingsSectionProfileDetails) {
        text = localizedString(@"Profile Details");
    }
    else if (section == PTKAppSettingsSectionAccountDetails) {
        text = localizedString(@"Account Details");
    }
    else if (section == PTKAppSettingsSectionAppSettings) {
        text = localizedString(@"App Settings");
    }
    else if (section == PTKAppSettingsSectionSupport) {
        text = localizedString(@"Support");
    }
    else if (section == PTKAppSettingsSectionAbout) {
        text = localizedString(@"About");
    }
    text = [text uppercaseString];
    headerText.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName : @(2.0f)}];

    [headerText sizeToFit];
    headerText.frame = CGRectMake(16.0f, 24.0f, headerText.width, headerText.height);
    [header addSubview:headerText];
    
    return header;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return PTKAppSettingsSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PTKAppSettingsSection currentSection = section;
    
    NSInteger sectionOffset = section * 10;
    
    switch(currentSection) {
        case PTKAppSettingsSectionAvatar:
            return PTKAppSettingsAvatarRowCount - sectionOffset;
            break;
            
        case PTKAppSettingsSectionProfileDetails:
            return PTKAppSettingsProfileDetailsRowCount - sectionOffset;
            break;
            
        case PTKAppSettingsSectionAccountDetails:
            return PTKAppSettingsAccountDetailsRowCount - sectionOffset;
            break;

        case PTKAppSettingsSectionAppSettings:
            return PTKAppSettingsAppSettingsRowCount - sectionOffset;
            break;

        case PTKAppSettingsSectionSupport:
            return PTKAppSettingsSupportRowCount - sectionOffset;
            break;

        case PTKAppSettingsSectionAbout:
            return PTKAppSettingsAboutRowCount - sectionOffset;
            break;

        case PTKAppSettingsSectionLogOutDelete:
            if ([[PTKConfiguration sharedInstance] showLogOutButton]) {
                return PTKAppSettingsLogOutDeleteRowCount - sectionOffset;
            }
            else {
                return PTKAppSettingsLogOutDeleteRowCount - 2 - sectionOffset;
            }
            break;

        case PTKAppSettingsSectionRate:
            return PTKAppSettingsRateRowCount - sectionOffset;
            break;

        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = @"";
    NSString *detailText = @"";
    
    NSUInteger row = indexPath.section * 10 + indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PTKAppSettingsCell"];
    if (cell == nil) {
        cell = [[PTKSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"PTKAppSettingsCell"];
        
        cell.layoutMargins = UIEdgeInsetsMake(15.0f, 0.0f, 0.0f, 0.0f);
        cell.preservesSuperviewLayoutMargins = NO;
    }
    
    UIView *accessoryView = nil;
    UITableViewCellAccessoryType accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.font = [PTKFont regularFontOfSize:16.0f];
    cell.textLabel.textColor = [UIColor darkTextColor];
    cell.detailTextLabel.font = [PTKFont regularFontOfSize:16.0f];
    UIColor *detailTextColor = [UIColor darkTextColor];
    
    if (indexPath.section != PTKAppSettingsSectionRate) {
        [cell addBottomSeparatorWithColor:[PTKColor settingsSeparatorColor]];
    }
    
    if (row == PTKAppSettingsAvatarRowMain) {
        UITableViewCell *avatarCell = [tableView dequeueReusableCellWithIdentifier:@"PTKAppSettingsAvatarCell"];

        if (avatarCell == nil) {
            avatarCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PTKAppSettingsAvatarCell"];
            avatarCell.selectionStyle = UITableViewCellSelectionStyleNone;
            avatarCell.backgroundColor = [PTKColor almostWhiteColor];

            UILabel *changePhotoLabel = [[UILabel alloc] init];
            changePhotoLabel.text = localizedString(@"Change Profile Photo");
            changePhotoLabel.font = [PTKFont regularFontOfSize:14.0f];
            changePhotoLabel.textColor = [PTKColor brandColor];
            [changePhotoLabel sizeToFit];
            changePhotoLabel.center = CGPointMake(avatarCell.contentView.center.x, 165.0f);
            changePhotoLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [avatarCell.contentView addSubview:changePhotoLabel];

            if (_editableAvatarView == nil) {
                _editableAvatarView = [[PTKEditableAvatarView alloc] initWithFrame:CGRectMake((self.view.width/2)-60, 20, 120, 120)];
                [_editableAvatarView updateImageContainerWithAvatarForUserId:[PTKUser currentUser].userId];
                _editableAvatarView.showsCameraIcon = NO;
                _editableAvatarView.showsPlusOverlay = NO;
                _editableAvatarView.delegate = self;
                _editableAvatarView.tintColor = [UIColor blueColor];
            }
            [avatarCell.contentView addSubview:_editableAvatarView];
        }

        return avatarCell;
    }
    else if (row == PTKAppSettingsProfileDetailsRowName) {
        text = localizedString(@"Name");
        accessoryView = _userNameTextField;
        _userNameTextField.frame = CGRectMake(0, 0, cell.contentView.width-20, cell.contentView.height);
    }
    else if (row == PTKAppSettingsProfileDetailsRowUsername) {
        text = localizedString(@"Username");
        detailText = [NSString stringWithFormat:@"@%@", [PTKData sharedInstance].session.username];
        
        if ([PTKData sharedInstance].session.needsUsername) {
            cell.textLabel.textColor = [PTKColor redActionColor];

            int maxUsernameCharCount = 15;
            if (detailText.length > maxUsernameCharCount) {
                detailText = [NSString stringWithFormat:@"%@...", [detailText substringToIndex:maxUsernameCharCount]];
            }
            detailTextColor = [PTKColor redActionColor];
            
            UIImageView* warningView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ic_warning"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            warningView.tintColor = [PTKColor redActionColor];
            warningView.contentMode = UIViewContentModeScaleAspectFit;
            warningView.frame = CGRectMake(0, 0, 30, 20);
            accessoryView = warningView;
        }
    }
    else if (row == PTKAppSettingsProfileDetailsRowPrivacy) {
        text = localizedString(@"Privacy");
        accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (row == PTKAppSettingsAccountDetailsRowPhone) {
        text = localizedString(@"Phone");
        
        NSString *phoneNumber = [PTKData sharedInstance].session.phoneNumber;
        NSString *sanitizedPhoneNumber = [PTKPhoneUtility sanitizePhoneNumber:phoneNumber];
        NSString *phoneFormatted = [[RMPhoneFormat instance] format:sanitizedPhoneNumber];
        if (phoneFormatted) {
            sanitizedPhoneNumber = phoneFormatted;
        }
        detailText = sanitizedPhoneNumber;
    }
    else if (row == PTKAppSettingsAccountDetailsRowEmail) {
        text = localizedString(@"Email");
        detailText = [[PTKData sharedInstance].session primaryEmail];
        
        if (![[PTKData sharedInstance].session primaryEmailIsVerified]) {
            UIImageView* warningView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"ic_warning"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            warningView.tintColor = [PTKColor redActionColor];
            warningView.contentMode = UIViewContentModeScaleAspectFit;
            warningView.frame = CGRectMake(0, 0, 30, 20);
            accessoryView = warningView;
            detailTextColor = [PTKColor redActionColor];
        }
    }
//    else if (row == PTKAppSettingsAccountDetailsRowPassword) {
//        text = localizedString(@"Password");
//        accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
    else if (row == PTKAppSettingsAccountDetailsRowPairedAccounts) {
        text = localizedString(@"Paired Accounts");
        accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (row == PTKAppSettingsAppSettingsRowNotifications) {
        text = localizedString(@"Notifications");
        accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (row == PTKAppSettingsAppSettingsRowDataUsage) {
        text = localizedString(@"Data Usage");
        accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (row == PTKAppSettingsSupportRowHelpCenter) {
        text = localizedString(@"Help Center");
        accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (row == PTKAppSettingsSupportRowContactUs) {
        text = localizedString(@"Contact Us");
        detailText = @"support@airtime.com";
        detailTextColor = [PTKColor blueActionColor];
    }
    else if (row == PTKAppSettingsAboutRowTerms) {
        text = localizedString(@"Terms of Service");
    }
    else if (row == PTKAppSettingsAboutRowLicenses) {
        text = localizedString(@"Licenses");
    }
    else if (row == PTKAppSettingsLogOutDeleteRowLogOut) {
        text = localizedString(@"Log Out");
    }
    else if (row == PTKAppSettingsLogOutDeleteRowAnalyticsToasts) {
        text = localizedString(@"Analytics Toasts");
        accessoryView = _analyticsToastsSwitch;
    }
    else if (row == PTKAppSettingsLogOutDeleteRowDelete) {
        text = localizedString(@"Delete Account");
        cell.textLabel.textColor = [PTKColor redActionColor];
    }
    else if (row == PTKAppSettingsRateRowMain) {
        UITableViewCell *rateThisAppCell = [tableView dequeueReusableCellWithIdentifier:@"PTKAppSettingsRateCell"];
        
        if (rateThisAppCell == nil) {
            rateThisAppCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PTKAppSettingsRateCell"];
            rateThisAppCell.selectionStyle = UITableViewCellSelectionStyleNone;
            rateThisAppCell.backgroundColor = [PTKColor almostWhiteColor];
            
            UIImageView *rateAppImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rate_app"]];
            rateAppImage.center = CGPointMake(rateThisAppCell.center.x, 50.0f);
            rateAppImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            [rateThisAppCell addSubview:rateAppImage];
            
            UILabel *rateLabel = [[UILabel alloc] init];
            rateLabel.text = localizedString(@"Rate the app!");
            rateLabel.font = [PTKFont regularFontOfSize:14.0f];
            rateLabel.textColor = [PTKColor brandColor];
            [rateLabel sizeToFit];
            rateLabel.center = CGPointMake(rateThisAppCell.center.x, 92.0f);
            rateLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            
            
            
            [rateThisAppCell addSubview:rateLabel];
        }

        return rateThisAppCell;
    }
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = detailText;
    cell.detailTextLabel.textColor = detailTextColor;
    
    cell.accessoryView = accessoryView;
    cell.accessoryType = accessoryType;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = indexPath.section * 10 + indexPath.row;
    
    if (row == PTKAppSettingsAvatarRowMain) {
        [self editableAvatarViewWasTapped:_editableAvatarView];
    }
    else if (row == PTKAppSettingsProfileDetailsRowName) {
        _userNameTextField.userInteractionEnabled = YES;
        [_userNameTextField becomeFirstResponder];
    }
    else if (row == PTKAppSettingsProfileDetailsRowUsername) {
        PTKEmailPickerViewController* usernamePicker =[[PTKEmailPickerViewController alloc] initWithControllerType:PTKAccountUpdatePickerTypeUsername];
        [self.navigationController pushViewController:usernamePicker animated:YES];
    }
    else if (row == PTKAppSettingsAccountDetailsRowPhone) {
        PTKPhoneChangeViewController* phone = [[PTKPhoneChangeViewController alloc] init];
        [self.navigationController pushViewController:phone animated:YES];
    }
    else if (row == PTKAppSettingsAccountDetailsRowEmail) {
        PTKEmailPickerViewController* emailPicker =[[PTKEmailPickerViewController alloc] init];
        [self.navigationController pushViewController:emailPicker animated:YES];
    }
    else if (row == PTKAppSettingsProfileDetailsRowPrivacy) {
        PTKPrivacySettingsViewController *privacy = [[PTKPrivacySettingsViewController alloc] init];
        [self.navigationController pushViewController:privacy animated:YES];
    }
    else if (row == PTKAppSettingsAccountDetailsRowPairedAccounts) {
        PTKPairedAccountSettingsViewController *pairedAccounts = [[PTKPairedAccountSettingsViewController alloc] init];
        [self.navigationController pushViewController:pairedAccounts animated:YES];
    }
    else if (row == PTKAppSettingsAppSettingsRowNotifications) {
        PTKNotificationSettingsViewController *notifications = [[PTKNotificationSettingsViewController alloc] init];
        [self.navigationController pushViewController:notifications animated:YES];
    }
    else if (row == PTKAppSettingsAppSettingsRowDataUsage) {
        PTKDataUsageSettingsViewController *dataUsage = [[PTKDataUsageSettingsViewController alloc] init];
        [self.navigationController pushViewController:dataUsage animated:YES];
    }
    else if (row == PTKAppSettingsSupportRowHelpCenter) {
        SVWebViewController* webVC = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://support.airtime.com/hc/en-us"]];
        webVC.title = localizedString(@"Help Center");
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if (row == PTKAppSettingsSupportRowContactUs) {
        [self contactUsAction];
    }
    else if (row == PTKAppSettingsAboutRowTerms) {
        SVWebViewController *webVC = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:kAirtimeTermsOfServiceURL]];
        webVC.title = localizedString(@"Terms of Service");
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if (row == PTKAppSettingsAboutRowLicenses) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Licenses" ofType:@"htm" inDirectory:nil];
        SVWebViewController *webVC = [[SVWebViewController alloc] initWithURL:[NSURL fileURLWithPath:path]];
        webVC.title = localizedString(@"Licenses");
        [self.navigationController pushViewController:webVC animated:YES];
    }
    else if (row == PTKAppSettingsLogOutDeleteRowLogOut) {
        [self askForLogOut];
    }
    else if (row == PTKAppSettingsLogOutDeleteRowDelete) {
        [self askForDeleteAccount];
    }
    else if (row == PTKAppSettingsRateRowMain) {
//        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.3")) {
//            [SKStoreReviewController requestReview];
//        }
//        else {
            [[UIApplication sharedApplication] openAppStore];
//        }
    }
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
    [[PTKS3Uploader sharedInstance] uploadUserAvatar:view.image shouldChangeFilename:YES];
}

#pragma mark - UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _userNameTextField) {
        _isEditingName = YES;
        
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:localizedString(@"Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelNameButtonPressed)];
        self.navigationItem.leftBarButtonItem = cancel;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _userNameTextField) {
        [self updateUserName];
        _isEditingName = NO;
        _userNameTextField.userInteractionEnabled = NO;
    }
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _userNameTextField) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)cancelNameButtonPressed {
    _userNameTextField.text = [[PTKAppState sharedInstance] getUserDisplayName];
    [_userNameTextField resignFirstResponder];
}

#pragma mark -

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
        return NO;
    }
    
    _isUpdatingUserName = YES;
    
    NSDictionary *params = @{@"firstName": firstName, @"lastName": lastName};
    PTKAPICallback *callback = [PTKAPI callbackWithTarget:self selector:@selector(onDidUpdateUserProperties:)];
    [PTKAPI updateUserProperties:params callback:callback];
    
    // Update tracking properties when modifying the user
    [PTKEventTracker updateServerProperties];
    [PTKEventTracker track:PTKEventTypeUserFullnameSet withProperties:@{@"characterCount": @(fullName.length)}];
    
    return YES;
}

#pragma mark - Contact

- (void)contactUsAction {
    PTKAlertController *alert = [PTKAlertController alertControllerWithTitle:localizedString(@"Include Airtime Logs?") message:localizedString(@"Do you want to include Airtime logs in your message? If you are reporting an issue this could help us investigate it.")];
    
    [alert addButtonWithTitle:localizedString(@"Yes") block:^{
        [self presentMailComposerAndIncludeLogs:YES];
    }];
    
    [alert addButtonWithTitle:localizedString(@"No") block:^{
        [self presentMailComposerAndIncludeLogs:NO];
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)presentMailComposerAndIncludeLogs:(BOOL)includeLogs {
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    if (!mailComposeViewController) {
        return;
    }
    
    mailComposeViewController.mailComposeDelegate = self;
    
    [mailComposeViewController setToRecipients:@[[[PTKConfiguration sharedInstance] supportEmail]]];
    [mailComposeViewController setSubject:[[PTKConfiguration sharedInstance] feedbackSubject]];
    
    NSMutableString *prepopulatedMessageBody = [[NSMutableString alloc] init];
    [prepopulatedMessageBody appendFormat:@"\n\n\n------------- Diagnostic Info -------------\n"];
    [prepopulatedMessageBody appendFormat:@"Name: %@\n", [[PTKAppState sharedInstance] getUserDisplayName]];
    [prepopulatedMessageBody appendFormat:@"User ID: %@\n", [[PTKAppState sharedInstance] getUserId]];
    [prepopulatedMessageBody appendFormat:@"Device: %@\n", [[UIDevice currentDevice] model]];
    [prepopulatedMessageBody appendFormat:@"OS: %@\n", [[UIDevice currentDevice] systemVersion]];
    [prepopulatedMessageBody appendFormat:@"Airtime version: %@\n", getAppVersion()];
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


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Log Out / Delete

- (void)askForLogOut {
    PTKActionSheetController *actionSheetController = [PTKActionSheetController actionSheetControllerWithTitle:nil message:NSLocalizedString(@"Are you sure you wish to log out?",0)];
    [actionSheetController addDestructiveButtonWithTitle:NSLocalizedString(@"Log Out",0) block:^{
        [[PTKAppState sharedInstance] logout];
    }];
    [actionSheetController addCancelButtonWithTitle:NSLocalizedString(@"Cancel", 0)];
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

- (void)askForDeleteAccount {
    PTKActionSheetController *actionSheetController = [PTKActionSheetController actionSheetControllerWithTitle:nil message:NSLocalizedString(@"Are you sure you want to delete your account? All of your groups, friends and messages will be removed. You can't undo this action.",0)];
    [actionSheetController addDestructiveButtonWithTitle:NSLocalizedString(@"Delete Account",0) block:^{
        PTKAlertController *alertView = [PTKAlertController alertControllerWithTitle:NSLocalizedString(@"Delete Account", 0) message:NSLocalizedString(@"Are you really sure you want to permanently delete your account and all related data? There's no turning back!", 0)];
        [alertView addCancelButtonWithTitle:NSLocalizedString(@"Cancel", 0)];
        [alertView addDestructiveButtonWithTitle:@"DELETE ACCOUNT" block:^{
            PTKAPICallback *callback = [PTKAPI callbackWithTarget:self selector:@selector(onDidDeleteUser:)];
            [PTKAPI deleteUserWithCallback:callback];
        }];
        
        [self presentViewController:alertView animated:YES completion:nil];
        
    }];
    [actionSheetController addCancelButtonWithTitle:NSLocalizedString(@"Cancel", 0)];
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

#pragma mark - AnalyticsToasts

- (void)analyticsToastSwitchDidChange:(UISwitch *)sender {
    [PTKUserDefaults setValue:[NSNumber numberWithBool:sender.on] forKey:PTKUserDefaultsDisplayAnalyticsToasts];
}

#pragma mark - PTKAPICallback methods

- (void)onDidDeleteUser:(PTKAPIResponse *)response {
    if (response.error) {
        [self showAlertWithTitle:@"Oops" andMessage:NSLocalizedString(@"Something went wrong when trying to delete your account. Maybe it's a ~signal~? (*wink* *wink*)", 0)];
        return;
    }
    
    [[PTKAppState sharedInstance] logout];
}


- (void)onDidUpdateUserProperties:(PTKAPIResponse *)response {
    _isUpdatingUserName = NO;
    
    if (response.error) {
        [self showAlertWithTitle:NSLocalizedString(@"Error", 0) andMessage:response.error.localizedDescription];
        return;
    }
    
    [PTKData sharedInstance].session = [[PTKSession alloc] initWithJSON:response.JSON];
    
    _userNameTextField.text = [[PTKAppState sharedInstance] getUserDisplayName];
}

- (void)onSessionUpdated {
    [_tableView reloadData];
}


@end
