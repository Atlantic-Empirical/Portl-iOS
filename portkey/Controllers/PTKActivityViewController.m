//
//  PTKActivityViewController.m
//  portkey
//
//  Created by Adam Bellard on 7/14/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKActivityViewController.h"

@interface PTKActivityItemProvider : UIActivityItemProvider
@end

@implementation PTKActivityItemProvider

-(id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(UIActivityType)activityType {
    if (activityType == UIActivityTypePostToTwitter && [self.placeholderItem isKindOfClass:[NSString class]]) {
        NSString *item = self.placeholderItem;
        item = [item stringByReplacingOccurrencesOfString:@"Airtime" withString:@"@airtime"];
        return item;
    } else {
        return self.placeholderItem;
    }
}

@end


@implementation PTKActivityViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return YES;
}

-(instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray<__kindof UIActivity *> *)applicationActivities {
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:activityItems.count];
    for (id item in activityItems) {
        if ([item isKindOfClass:[NSString class]]) {
            PTKActivityItemProvider *provider = [[PTKActivityItemProvider alloc] initWithPlaceholderItem:item];
            [items addObject:provider];
        } else {
            [items addObject:item];
        }
    }
    return [super initWithActivityItems:items applicationActivities:applicationActivities];
}

@end
