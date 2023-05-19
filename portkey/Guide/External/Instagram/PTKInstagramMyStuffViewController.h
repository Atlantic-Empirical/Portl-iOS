//
//  PTKInstagramMyStuffViewController.h
//  portkey
//
//  Created by Rodrigo Sieiro on 5/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKBaseViewController.h"

@protocol PTKInstagramMyStuffDelegate <NSObject>

@required
- (void)instagramController:(PTKBaseViewController *)viewController prepareInstagramMessageWithURL:(NSString *)url;

@end

@interface PTKInstagramMyStuffViewController : PTKBaseViewController

@property (nonatomic) BOOL expanded;
@property (nonatomic, weak) id<PTKInstagramMyStuffDelegate> delegate;

@end
