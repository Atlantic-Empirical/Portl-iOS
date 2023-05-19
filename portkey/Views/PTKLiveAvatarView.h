//
//  PTKLiveAvatarView.h
//  portkey
//
//  Created by Rodrigo Sieiro on 15/6/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTKLiveAvatarView : UIView

@property (nonatomic, strong, readonly) NSString *userId;

- (instancetype)initWithUserId:(NSString *)userId frame:(CGRect)frame;

@end
