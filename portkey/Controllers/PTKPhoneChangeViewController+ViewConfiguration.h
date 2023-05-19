//
//  PTKPhoneChangeViewController+ViewConfiguration.h
//  portkey
//
//  Created by Robert Reeves on 10/1/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import "PTKPhoneChangeViewController.h"

@interface PTKPhoneChangeViewController (ViewConfiguration) <PTKPhoneInputViewDelegate, PTKCodeInputViewDelegate>

- (void)loadFirstView;
- (void)loadSecondView;
- (void)loadThirdView;
- (void)loadFourthView;

@end
