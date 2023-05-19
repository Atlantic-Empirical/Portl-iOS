//
//  PTKCopyHelper.h
//  portkey
//
//  Created by Rodrigo Sieiro on 26/1/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKCopyHelper : NSObject

// URLs

+ (NSString *)userUrl;
+ (NSURL *)fullUserUrl;
+ (NSString *)userUrlForUser:(PTKUser *)user;

// App Invites

+ (NSString *)appInviteText;
+ (NSString *)appInviteTextFromUser:(PTKUser *)user;
+ (NSString *)appInviteTextForServerSideSMS;
+ (NSString *)appInviteTextForServerSideSMSFromUser:(PTKUser *)user;

// Room Invites

+ (NSString *)inviteTextForRoom:(PTKRoom *)room link:(NSString *)link;

// Chat app Invite

+ (NSString *)appInviteTextForFacebookMessenger;
+ (NSString *)inviteTextForChatAppName:(NSString *)chatAppName link:(NSString *)link;

@end
