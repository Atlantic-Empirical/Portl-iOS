##Adding new notificaiton actions and categories 

### Actions: 
* Go to `PTPermissionManager.h` and add a new string, like this `extern NSString* const kNotificationActionWho;` 
* Go to `PTPermissionManager.m` and add the value like this: `NSString* const kNotificationActionWho = @"ACTION_KICKED_WHO";`
* In the same file scroll down to `+ (void)registerForNotifications {`
* Add this block:

```objective-c
    UIMutableUserNotificationAction* actionWho = [[UIMutableUserNotificationAction alloc] init];
    actionWho.identifier = kNotificationActionWho;
    actionWho.title = localizedString(@"Who?");
    actionWho.authenticationRequired = NO;
    actionWho.activationMode = UIUserNotificationActivationModeForeground;
    actionWho.destructive = NO;
```
* Go to the `PTKPushManger.m` and scroll down to the function `-(void)handleNotificationWithIdentifier `:
* Add a new if statement for the new identifier or add it to and old case. (in this case we can for example add it to the `NotificationActionViewProfile` methods)
* Note: make sure you end the method with `if (completionHandler) completionHandler();` else it won't work.

### Categories: 
* Go to `PTPermissionManager.h` and add a new string, like this `extern NSString* const kNotificationRoomCategoryKickedByUser;` 
* Go to `PTPermissionManager.m` and add the value like this: `NSString* const kNotificationRoomCategoryKickedByUser = @"CATEGORY_ROOM_KICKED_BY_USER";
;`
* In the same file scroll down to `+ (void)registerForNotifications {`
* Add this block

```objective-c
    NSArray* categoryRoomKickedByUserActions = @[actionWho];
    UIMutableUserNotificationCategory* categoryRoomKickedByUser = [[UIMutableUserNotificationCategory alloc] init];
    categoryRoomKickedByUser.identifier = kNotificationCategoryRoomKickedByUser;
    [categoryRoomKickedByUser setActions:categoryRoomKickedByUserActions forContext:UIUserNotificationActionContextDefault];
    [categoryRoomKickedByUser setActions:categoryRoomKickedByUserActions forContext:UIUserNotificationActionContextMinimal];
```
* Add the end of the method, add the new category to the `UIUserNotificationSettings *settings`-array
