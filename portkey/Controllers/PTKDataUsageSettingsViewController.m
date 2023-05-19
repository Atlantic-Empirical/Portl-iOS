//
//  PTKDataUsageSettingsViewController.m
//  portkey
//
//  Created by Adam Bellard on 2/3/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKDataUsageSettingsViewController.h"
#import "PTKSettingsTableViewCell.h"

typedef NS_ENUM(NSUInteger, PTKDataUsageSettingsRow) {
    PTKDataUsageSettingsRowAutoPlayVideos,
    PTKDataUsageSettingsRowConserveMobileData,
    PTKDataUsageSettingsRowCount,
};

@interface PTKDataUsageSettingsViewController () <UITableViewDelegate, UITableViewDataSource> {
    UITableView *_tableView;
    
    UILabel *_autoVideoDetailLabel;
    
    UISwitch *_useLessDataSwitch;
    UILabel *_useLessDataDescription;
}

@end

@implementation PTKDataUsageSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = localizedString(@"DATA USAGE");
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [PTKColor almostWhiteColor];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    _useLessDataSwitch = [[UISwitch alloc] init];
    [_useLessDataSwitch addTarget:self action:@selector(lowDataSwitchDidChange:) forControlEvents:UIControlEventValueChanged];
    [_useLessDataSwitch setOn:[PTKUserDefaults boolForKey:PTKUserDefaultsSessionKeyDataSavingMode defaultTo:isLowPowerDevice()]];

    _useLessDataDescription = [[UILabel alloc] init];
    _useLessDataDescription.text = localizedString(@"Reduces the amount of data used over cellular and WiFi networks. Video and image quality may be affected.");
    _useLessDataDescription.font = [PTKFont regularFontOfSize:12.0f];
    _useLessDataDescription.numberOfLines = 0;
    _useLessDataDescription.textAlignment = NSTextAlignmentLeft;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    header.backgroundColor = tableView.backgroundColor;
    
    [header addBottomSeparatorWithColor:[PTKColor settingsSeparatorColor]];
    
    UILabel *headerText = [[UILabel alloc] init];
    headerText.font = [PTKFont boldFontOfSize:12.0f];
    headerText.textColor = [PTKColor mediumGrayColor];

    NSString *text = localizedString(@"USAGE SETTINGS");
    headerText.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSKernAttributeName : @(2.0f)}];
    
    [headerText sizeToFit];
    headerText.frame = CGRectMake(16.0f, 24.0f, headerText.width, headerText.height);
    [header addSubview:headerText];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGSize labelSize = [_useLessDataDescription sizeThatFits:CGSizeMake(self.view.width - 30.0f, self.view.height)];
    
    return labelSize.height + 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] init];
    footer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    footer.backgroundColor = tableView.backgroundColor;

    [footer addSubview:_useLessDataDescription];
    
    return footer;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    _useLessDataDescription.frame = CGRectMake(15.0f, 10.0f, view.width - 30.0f, view.height - 20.0f);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return PTKDataUsageSettingsRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[PTKSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.textLabel.font = [PTKFont regularFontOfSize:16.0f];
        
        [cell addBottomSeparatorWithColor:[PTKColor settingsSeparatorColor]];
    }
    

    if (indexPath.row == PTKDataUsageSettingsRowAutoPlayVideos) {
        cell.textLabel.text = localizedString(@"Auto-Play Videos");
        _autoVideoDetailLabel = cell.detailTextLabel;
        
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
        cell.detailTextLabel.textColor = [PTKColor brandColor];
    }
    else if (indexPath.row == PTKDataUsageSettingsRowConserveMobileData) {
        cell.textLabel.text = localizedString(@"Conserve Mobile Data");
        cell.accessoryView = _useLessDataSwitch;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == PTKDataUsageSettingsRowAutoPlayVideos) {
        [self askForVideoAutoPlaySettings];
    }
}

#pragma mark - actions

- (void)askForVideoAutoPlaySettings {
    PTKActionSheetController *actionSheetController = [PTKActionSheetController actionSheetControllerWithTitle:nil message:NSLocalizedString(@"Auto-Play Videos",0)];
    [actionSheetController addButtonWithTitle:NSLocalizedString(@"WiFi Only",0) block:^{
        [PTKUserDefaults setValue:kKeyAutoPlayWifi forKey:PTKUserDefaultsAutoVideoLoadOption];
        _autoVideoDetailLabel.text = NSLocalizedString(@"WiFi Only",0);
    }];
    [actionSheetController addButtonWithTitle:NSLocalizedString(@"WiFi & Cellular",0) block:^{
        [PTKUserDefaults setValue:kKeyAutoPlayCellular forKey:PTKUserDefaultsAutoVideoLoadOption];
        _autoVideoDetailLabel.text = NSLocalizedString(@"WiFi & Cellular",0);
    }];
    [actionSheetController addDestructiveButtonWithTitle:NSLocalizedString(@"Disable",0) block:^{
        [PTKUserDefaults setValue:kKeyAutoPlayNone forKey:PTKUserDefaultsAutoVideoLoadOption];
        _autoVideoDetailLabel.text = NSLocalizedString(@"Disabled",0);
    }];
    [actionSheetController addCancelButtonWithTitle:NSLocalizedString(@"Cancel", 0) block:nil];
    [self presentViewController:actionSheetController animated:YES completion:nil];
}

- (void)lowDataSwitchDidChange:(UISwitch*)sender {
    [PTKUserDefaults setValue:@(_useLessDataSwitch.on) forKey:PTKUserDefaultsSessionKeyDataSavingMode];
    
    if (_useLessDataSwitch.on) {
        [PTKUserDefaults setValue:kKeyAutoPlayNone forKey:PTKUserDefaultsAutoVideoLoadOption];
        _autoVideoDetailLabel.text = NSLocalizedString(@"Disabled",0);
    } else {
        [PTKUserDefaults setValue:kKeyAutoPlayCellular forKey:PTKUserDefaultsAutoVideoLoadOption];
        _autoVideoDetailLabel.text = NSLocalizedString(@"WiFi & Cellular",0);
    }
}


@end
