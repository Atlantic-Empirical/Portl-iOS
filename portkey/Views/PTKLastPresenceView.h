//
//  PTKLastPresenceView.h
//  portkey
//
//  Created by Rodrigo Sieiro on 14/12/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKLastPresenceView : UIView

@property (nonatomic, strong) UIColor *roomColor;

- (void)displayUsersHere:(NSArray *)usersHere usersNoLongerHere:(NSArray *)usersNoLongerHere;
- (void)updateUsersTyping:(NSArray *)usersTyping;

@end
