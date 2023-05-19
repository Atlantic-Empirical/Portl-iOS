//
//  PTKS3Uploader.h
//  portkey
//
//  Created by Stanislav Nikiforov on 4/23/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKBackgroundQueue.h"

FOUNDATION_EXPORT const CGFloat kImageCompressionInternal;
FOUNDATION_EXPORT const CGFloat kImageCompressionHigh;
FOUNDATION_EXPORT const CGFloat kImageCompressionThumb;

@interface PTKS3Uploader : PTKBackgroundQueue

@property (readonly) NSString *baseLocalPath;

+ (PTKS3Uploader *)sharedInstance;
- (void)uploadUserAvatar:(UIImage *)avatar shouldChangeFilename:(BOOL)changeFilename;
- (NSArray *)messagesForRoom:(NSString *)roomId;
- (void)removeOrCancelMessageWithClientId:(NSString *)clientId;
- (void)enqueueMessage:(PTKMessage *)message andSend:(BOOL)send;

BOOL ScaleImageForS3Upload(UIImage *originalImage, UIImage **scaledImage);

@end
