//
//  PTKCountryCodePickerViewController.h
//  portkey
//
//  Created by Daniel Amitay on 4/22/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKBaseTableViewController.h"

@class PTKCountryCodePickerViewController;
@protocol PTKCountryCodePickerDelegate <NSObject>

@optional
- (void)countryCodePickerWantsDismiss:(PTKCountryCodePickerViewController *)picker;
- (void)countryCodePicker:(PTKCountryCodePickerViewController *)picker didPickCountryCode:(NSString *)isoCountryCode;

@end

@interface PTKCountryCodePickerViewController : PTKBaseTableViewController

@property (nonatomic, weak) id<PTKCountryCodePickerDelegate> delegate;

- (instancetype)initWithCountryCode:(NSString *)isoCountryCode;

@end
