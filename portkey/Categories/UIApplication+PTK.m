//
//  UIApplication+PTK.m
//  portkey
//
//  Created by Daniel Amitay on 11/30/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import "UIApplication+PTK.h"

@implementation UIApplication (PTK)

- (BOOL)isTestFlightBuild {
#ifdef DEBUG
    return NO;
#else
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    return [receiptURL.lastPathComponent isEqualToString:@"sandboxReceipt"];
#endif
}

- (BOOL)openAppStore {
    NSString *appStoreUrl = [NSString stringWithFormat:@"https://itunes.apple.com/app/airtime-group-video-chat/id%@?mt=8", APP_ID];
    NSURL *url = [NSURL URLWithString:appStoreUrl];
    if ([self canOpenURL:url]) {
        [self openURL:url options:@{} completionHandler:nil];
        return YES;
    }
    return NO;
}

- (BOOL)openTestFlight {
    NSURL *url = [NSURL URLWithString:@"itms-beta://"];
    
    if ([self canOpenURL:url]) {
        [self openURL:url options:@{} completionHandler:nil];
        return YES;
    }
    return NO;
}

- (BOOL)openAppropriateUpdateChannel {
    if ([self isTestFlightBuild]) {
        // Try to open the TestFlight app (intentionally not using canOpenURL...)
        if ([self openTestFlight]) {
            return YES;
        }
    }

    // Default to sending the user to the App Store
    return [self openAppStore];
}

@end
