//
//  PTKDebugView.h
//  portkey
//
//  Created by Daniel Amitay on 1/13/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTKDebugViewDelegate <NSObject>

@optional
- (void)debugViewSendLogsPressed;

@end

@interface PTKDebugView : UIView

@property (nonatomic, readonly) BOOL isVisible;
@property (weak, nonatomic) id<PTKDebugViewDelegate>delegate;

+ (PTKDebugView *)sharedInstance;

- (void)displayText:(NSString *)string forKey:(NSString *)key;
- (void)clearTextForKey:(NSString *)key;

- (void)show;
- (void)hide;

@end
