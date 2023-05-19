//
//  PTKServerSMSContactsView.h
//  portkey
//
//  Created by Daniel Amitay on 1/5/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKServerSMSContactsView;
@protocol PTKServerSMSContactsViewDelegate <NSObject>

- (void)serverSMSContactsViewDidChange:(PTKServerSMSContactsView *)contactsView;

@end

@interface PTKServerSMSContactsView : UIView

@property (nonatomic, weak) id <PTKServerSMSContactsViewDelegate> delegate;

@property (nonatomic, copy) NSArray *contacts;

@end
