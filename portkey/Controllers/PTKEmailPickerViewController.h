//
//  PTKEmailPickerViewController.h
//  portkey
//
//  Created by Robert Reeves on 1/21/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

typedef NS_ENUM(NSInteger, PTKAccountUpdatePickerType) {
    PTKAccountUpdatePickerTypeUnknown,
    PTKAccountUpdatePickerTypeEmail,
    PTKAccountUpdatePickerTypeUsername
};

@interface PTKEmailPickerViewController : PTKBaseViewController

@property (assign) BOOL presentedByInterstitial;

- (instancetype)initWithControllerType:(PTKAccountUpdatePickerType)pickerType;

@end
