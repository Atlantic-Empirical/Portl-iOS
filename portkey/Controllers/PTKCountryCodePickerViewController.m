//
//  PTKCountryCodePickerViewController.m
//  portkey
//
//  Created by Daniel Amitay on 4/22/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKCountryCodePickerViewController.h"
#import "PTKPhoneUtility.h"

@interface PTKCountryCodePickerViewController () {
    NSString *_initialIsoCountryCode;
    BOOL _firstResize;

    // NOTE: These have the same order
    NSMutableArray *_countryCodes;
    NSMutableArray *_isoCountryCodes;
    NSMutableArray *_countryNames;
}

@end

@implementation PTKCountryCodePickerViewController

#pragma mark - Lifecycle methods

- (instancetype)init {
    return [self initWithCountryCode:nil];
}

- (instancetype)initWithCountryCode:(NSString *)isoCountryCode {
    self = [super init];
    if (self) {
        _initialIsoCountryCode = isoCountryCode;

        if (!_initialIsoCountryCode) {
            _initialIsoCountryCode = [PTKPhoneUtility getHomeIsoCountryCode];
        } else {
            _initialIsoCountryCode = [_initialIsoCountryCode uppercaseString];
        }

        _firstResize = YES;

        NSMutableArray *countryNames = [NSMutableArray arrayWithCapacity:[PTKPhoneUtility countryPhoneCodes].count];
        NSLocale *locale = [NSLocale currentLocale];
        for (NSString *code in [[PTKPhoneUtility countryPhoneCodes] allKeys]) {
            NSString *displayName = [locale displayNameForKey:NSLocaleCountryCode value:code];
            [countryNames addObject:@{
                @"code":[[PTKPhoneUtility countryPhoneCodes] objectForKey:code],
                @"isoCode": code,
                @"name": displayName ? displayName : code
            }];
        }
        [countryNames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 objectForKey:@"name"] compare:[obj2 objectForKey:@"name"] options:0];
        }];

        _countryNames = [NSMutableArray arrayWithCapacity:countryNames.count];
        _countryCodes = [NSMutableArray arrayWithCapacity:countryNames.count];
        _isoCountryCodes = [NSMutableArray arrayWithCapacity:countryNames.count];

        for (NSDictionary *dict in countryNames) {
            [_countryNames addObject:[dict objectForKey:@"name"]];
            [_isoCountryCodes addObject:[dict objectForKey:@"isoCode"]];
            [_countryCodes addObject:[dict objectForKey:@"code"]];
        }
    }
    return self;
}

#pragma mark - View methods

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Country Code",0);

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel",0)
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(onCancel)];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (_firstResize) {
        if (_initialIsoCountryCode) {
            NSUInteger row = [_isoCountryCodes indexOfObject:_initialIsoCountryCode];
            if (row != NSNotFound) {
                //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
        _firstResize = NO;
    }
}


#pragma mark - Interface methods

- (void)onCancel {
    if ([self.delegate respondsToSelector:@selector(countryCodePickerWantsDismiss:)]) {
        [self.delegate countryCodePickerWantsDismiss:self];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _countryCodes.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"country"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"country"];
        cell.backgroundColor = [PTKColor almostWhiteColor];
        cell.textLabel.font = [PTKFont boldFontOfSize:16.0f];
    }

    NSString *isoCountryCode = [_isoCountryCodes objectAtIndex:indexPath.row];

    cell.imageView.image = [UIImage imageNamed:isoCountryCode];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (+%@)", [_countryNames objectAtIndex:indexPath.row], [_countryCodes objectAtIndex:indexPath.row]];

    cell.selected = [isoCountryCode isEqualToString:_initialIsoCountryCode];

    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *isoCountryCode = [_isoCountryCodes objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(countryCodePicker:didPickCountryCode:)]) {
        [self.delegate countryCodePicker:self didPickCountryCode:isoCountryCode];
    }
}

@end
