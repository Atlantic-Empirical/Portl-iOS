//
//  PTKInstagramMedia.h
//  portkey
//
//  Created by Rodrigo Sieiro on 6/10/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKModel.h"

@class PTKInstagramUser;
@interface PTKInstagramMedia : PTKModel

- (NSString *)type;
- (NSString *)url;
- (NSString *)text;
- (NSString *)imageUrl;
- (CGSize)imageSize;
- (NSString *)videoUrl;
- (CGSize)videoSize;
- (NSDate *)createdAt;
- (NSUInteger)likesCount;
- (NSUInteger)commentsCount;
- (PTKInstagramUser *)postedBy;

@property (nonatomic, assign) CGFloat cachedHeight;

@end
