//
//  PTKWebViewController.h
//  portkey
//
//  Created by Adam Bellard on 9/16/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKWebViewController;
@protocol PTKWebViewControllerDelegate <UINavigationControllerDelegate>

- (void)webViewWantsToDismiss:(PTKWebViewController *)webView;

@end

@interface PTKWebViewController : UINavigationController

- (instancetype)initWithAddress:(NSString*)urlString;
- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

@property (nonatomic, copy) NSString *doneButtonTitle;
@property (nonatomic, strong) UIColor *barsTintColor;
@property (nonatomic, assign) BOOL autorotateLock;
@property (nonatomic, assign) BOOL hideTabBar;
@property (nonatomic, weak) id<UIWebViewDelegate> webViewDelegate;
@property (nonatomic, weak) id<PTKWebViewControllerDelegate> delegate;

@end
