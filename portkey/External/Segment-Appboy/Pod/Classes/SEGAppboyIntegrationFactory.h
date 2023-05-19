#import <Foundation/Foundation.h>
#import "SEGIntegrationFactory.h"

@interface SEGAppboyIntegrationFactory : NSObject<SEGIntegrationFactory>

+ (instancetype)instance;

- (void)saveLaunchOptions:(NSDictionary *)launchOptions;
- (void)saveRemoteNotification:(NSDictionary *)userInfo;
@end
