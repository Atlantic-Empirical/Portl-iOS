//
//  PTKInviteCell.h
//  portkey
//
//  Created by Rodrigo Sieiro on 1/6/15.
//  Copyright (c) 2015 Airtime Media. All rights reserved.
//

#import "PTKGenericCellDelegate.h"

static const CGFloat kInviteAvatarSize = 40.0f;
static const CGFloat kInviteAvatarMargin = 13.0f;
static const CGFloat kInviteNameSize = 17.0f;

typedef enum {
    PTKInviteCellButtonIndexAccept,
    PTKInviteCellButtonIndexClose
} PTKInviteCellButtonIndex;


@interface PTKInviteCell : UITableViewCell

@property (nonatomic, strong, readonly) NSString *roomId;
@property (nonatomic, weak) id<PTKGenericTableViewCellDelegate> delegate;

- (void)setRoomId:(NSString *)roomId;
- (void)setPending:(BOOL)pending result:(NSString *)result;

@end