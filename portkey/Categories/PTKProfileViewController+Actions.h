//
//  PTKProfileViewController+Actions.h
//  portkey
//
//  Created by Robert Reeves on 3/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKProfileViewController.h"
#import "PTKOnlinePresenceDataSource.h"
#import "PTKProfileRoomsViewController.h"
#import "PTKRoomCollectionViewCell.h"
#import "PTKPagingLayout.h"

@interface PTKProfileViewController (Actions) <UITextViewDelegate, PTKPaginatedDataSourceDelegate, PTKPagingLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate, PTKOnlinePresenceDataSourceDelegate, PTKRoomCollectionViewCellDelegate, PTKProfileRoomsViewControllerDelegate>

- (void)avatarImageAction:(id)sender;
- (void)friendsButtonAction:(id)sender;
- (void)roomsButtonAction:(id)sender;
- (void)shareButtonAction:(id)sender;
- (void)statusTextAction:(id)sender;
- (void)actionButtonAction:(id)sender;

- (void)backButtonAction:(id)sender;
- (void)settingsButtonAction:(id)sender;
- (void)optionsButtonAction:(id)sender;
- (void)cancelBioButtonAction:(id)sender;
- (void)doneBioButtonAction:(id)sender;

- (void)joinRoom:(PTKRoom *)room;
- (void)showNoRoomActionSheetForRoom:(PTKRoom *)room withTitle:(NSString *)title;

- (void)onDidBlockOrUnblockUser:(NSNotification *)n;

@end
