//
//  PTKSettingsTableViewCell.m
//  portkey
//
//  Created by Adam Bellard on 2/14/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKSettingsTableViewCell.h"

@implementation PTKSettingsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

@end
