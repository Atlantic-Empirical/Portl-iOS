//
//  PTKAttachmentsParser.h
//  portkey-extension
//
//  Created by Rodrigo Sieiro on 6/8/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTKAttachmentsParser : NSObject

- (void)parseAttachments:(NSArray *)attachments roomId:(NSString *)roomId body:(NSString *)body completion:(void (^)(NSArray *messages))completion;

@end
