//
//  PTKSnapShot.h
//  portkey
//
//  Created by Robert Reeves on 5/13/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKSnapShot : NSObject


+ (UIImage*)buildPhotoBoothArtifactWithSnapshot:(UIImage*)snapshot roomURL:(NSURL*)roomSlugURL presences:(NSArray*)presentArray room:(PTKRoom*)snapRoom publishingMemberCount:(NSUInteger)memberCount message:(PTKMessage*)currentMessage;


+ (UIImage *)snapshot:(UIView *)view andOverlayCameraImage:(UIImage *)cameraImage withFrame:(CGRect)frame;


@end
