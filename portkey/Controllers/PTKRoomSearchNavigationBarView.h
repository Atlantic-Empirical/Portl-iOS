//
//  PTKRoomSearchNavigationBarView.h
//  portkey
//
//  Created by Seth Samuel on 1/16/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTKRoomSearchNavigationBarViewDelegate <NSObject>

- (void) roomSearchNavigationBarViewDidCancel;
- (void) roomSearchNavigationBarViewDidSearch:(NSString*)term;

@end

@interface PTKRoomSearchNavigationBarView : UIView <UITextFieldDelegate>

@property (weak) id<PTKRoomSearchNavigationBarViewDelegate> delegate;
@property NSString *searchTerm;

@end
