//
//  PTKProfileViewController+View.m
//  portkey
//
//  Created by Robert Reeves on 3/16/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKProfileViewController+View.h"
#import "PTKProfileViewController+Data.h"
#import "PTKProfileViewController+Actions.h"
#import "PTKOnlinePresenceDataSource.h"
#import "PTKRoomCollectionViewCell.h"
#import "PTKRoomAddCollectionViewCell.h"
#import "PTKPagingLayout.h"
#import "FXBlurView.h"

@implementation PTKProfileViewController (View)

- (void)loadViewContent {
    CGFloat avatarSize = (IS_IPHONE5_OR_OLDER) ? 90.0f : 125.0f;
    CGFloat thinHeight = [PTKGraphics onePixelAtAnyScale];

    // Title Label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.titleLabel.font = [PTKFont boldFontOfSize:17.0f];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [PTKColor almostBlackColor];
    self.navigationItem.titleView = self.titleLabel;

    // Profile Image
    self.avatarImageView = [[PTKImageView alloc] initWithFrame:CGRectMake(ceilcg(self.view.width / 2.0f) - ceilcg(avatarSize / 2.0f), 0.0f, avatarSize, avatarSize)];
    self.avatarImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.avatarImageView.tintColor = [PTKColor brandColor];
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.userInteractionEnabled = YES;
    self.avatarImageView.layer.borderColor = [[PTKColor almostWhiteColor] colorWithAlphaComponent:0.3f].CGColor;
    self.avatarImageView.layer.borderWidth = 3.0f;
    self.avatarImageView.layer.cornerRadius = avatarSize / 2.0f;
    self.avatarImageView.layer.shouldRasterize = YES;
    self.avatarImageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageAction:)]];
    [self.view addSubview:self.avatarImageView];

    // Username
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 18.0f)];
    self.usernameLabel.textAlignment = NSTextAlignmentCenter;
    self.usernameLabel.adjustsFontSizeToFitWidth = YES;
    self.usernameLabel.minimumScaleFactor = 0.5f;
    self.usernameLabel.font = [PTKFont regularFontOfSize:13.0f];
    self.usernameLabel.textColor = [PTKColor brandColor];
    self.usernameLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.usernameLabel.layer.cornerRadius = 9.0f;
    self.usernameLabel.layer.shadowOpacity = 0.6f;
    self.usernameLabel.layer.shadowRadius = 1.0f;
    self.usernameLabel.layer.shadowOffset = CGSizeMake(0, 1.0f);
    self.usernameLabel.layer.shouldRasterize = YES;
    self.usernameLabel.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.usernameLabel.hidden = YES;
    [self.view addSubview:self.usernameLabel];

    // Top Line
    self.lineTop = [[UIView alloc] initWithFrame:CGRectMake(25.0f, self.avatarImageView.midY - 28.0f, self.view.width - 50.0f, thinHeight)];
    self.lineTop.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.lineTop.backgroundColor = [PTKColor grayColor];
    [self.view insertSubview:self.lineTop belowSubview:self.avatarImageView];

    // Bottom Line
    self.lineBottom = [[UIView alloc] initWithFrame:CGRectMake(25.0f, self.avatarImageView.midY + 28.0f, self.view.width - 50.0f, thinHeight)];
    self.lineBottom.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.lineBottom.backgroundColor = [PTKColor grayColor];
    [self.view insertSubview:self.lineBottom belowSubview:self.avatarImageView];

    // Friend Count
    self.friendCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.lineTop.x, self.avatarImageView.midY - 18.0f, self.avatarImageView.x - self.lineTop.x, 20.0f)];
    self.friendCountLabel.font = [PTKFont semiBoldFontOfSize:18.0f];
    self.friendCountLabel.textColor = [PTKColor brandColor];
    self.friendCountLabel.textAlignment = NSTextAlignmentCenter;
    self.friendCountLabel.alpha = 0;
    [self.view insertSubview:self.friendCountLabel belowSubview:self.avatarImageView];

    // "Friends"
    self.friendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.lineTop.x, self.friendCountLabel.maxY + 4.0f, self.avatarImageView.x - self.lineTop.x, 15.0f)];
    self.friendsLabel.font = [PTKFont semiBoldFontOfSize:13];
    self.friendsLabel.textColor = [PTKColor grayColor];
    self.friendsLabel.textAlignment = NSTextAlignmentCenter;
    self.friendsLabel.attributedText = [[NSAttributedString alloc] initWithString:localizedString(@"FRIENDS") attributes:@{NSKernAttributeName: @1}];
    self.friendsLabel.alpha = 0;
    [self.view insertSubview:self.friendsLabel belowSubview:self.avatarImageView];

    // Friends Button
    self.friendsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.friendsButton.frame = CGRectMake(self.lineTop.x, self.lineTop.y, self.friendCountLabel.width, self.lineBottom.y - self.lineTop.y);
    self.friendsButton.showsTouchWhenHighlighted = YES;
    self.friendsButton.enabled = NO;
    [self.friendsButton addTarget:self action:@selector(friendsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.friendsButton belowSubview:self.avatarImageView];

    // Room Count
    self.roomCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.avatarImageView.maxX, self.avatarImageView.midY - 18.0f, self.avatarImageView.x - self.lineTop.x, 20.0f)];
    self.roomCountLabel.font = [PTKFont semiBoldFontOfSize:18];
    self.roomCountLabel.textColor = [PTKColor brandColor];
    self.roomCountLabel.textAlignment = NSTextAlignmentCenter;
    self.roomCountLabel.alpha = 0;
    [self.view insertSubview:self.roomCountLabel belowSubview:self.avatarImageView];

    // "Rooms"
    self.roomsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.avatarImageView.maxX, self.roomCountLabel.maxY + 4.0f, self.avatarImageView.x - self.lineTop.x, 15.0f)];
    self.roomsLabel.font = [PTKFont semiBoldFontOfSize:13];
    self.roomsLabel.textColor = [PTKColor grayColor];
    self.roomsLabel.textAlignment = NSTextAlignmentCenter;
    self.roomsLabel.attributedText = [[NSAttributedString alloc] initWithString:localizedString(@"ROOMS") attributes:@{NSKernAttributeName: @1}];
    self.roomsLabel.alpha = 0;
    [self.view insertSubview:self.roomsLabel belowSubview:self.avatarImageView];

    // Rooms Button
    self.roomsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.roomsButton.frame = CGRectMake(self.avatarImageView.maxX, self.lineTop.y, self.roomCountLabel.width, self.lineBottom.y - self.lineTop.y);
    self.roomsButton.showsTouchWhenHighlighted = YES;
    self.roomsButton.enabled = NO;
    [self.roomsButton addTarget:self action:@selector(roomsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.roomsButton belowSubview:self.avatarImageView];

    // Status Title
    self.statusTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, self.avatarImageView.maxY + 10.0f, self.view.width - 20.0f, 14.0f)];
    self.statusTitleLabel.textColor = [PTKColor grayColor];
    self.statusTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.statusTitleLabel.font = [PTKFont semiBoldFontOfSize:12.0f];
    self.statusTitleLabel.alpha = 0;
    [self.view addSubview:self.statusTitleLabel];

    if (self.viewType == PTKProfileViewTypeOwn) {
        // Share Button
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareButton.frame = CGRectMake(self.view.midX - 30.0f, self.avatarImageView.maxY + 18.0f, 60.0f, 44.0f);
        self.shareButton.tintColor = [PTKColor brandColor];
        self.shareButton.alpha = 0;
        [self.shareButton setImage:[[UIImage imageNamed:@"room-share"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.shareButton];
    } else {
        // Status Text
        self.statusTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, self.statusTitleLabel.maxY + 2.0f, self.view.width - 20.0f, 22.0f)];
        self.statusTextLabel.textAlignment = NSTextAlignmentCenter;
        self.statusTextLabel.font = [PTKFont regularFontOfSize:17.0];
        self.statusTextLabel.adjustsFontSizeToFitWidth = YES;
        self.statusTextLabel.minimumScaleFactor = 0.7f;
        self.statusTextLabel.textColor = [PTKColor almostBlackColor];
        self.statusTextLabel.alpha = 0;
        [self.statusTextLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(statusTextAction:)]];
        [self.view addSubview:self.statusTextLabel];
    }

    if (self.viewType == PTKProfileViewTypeOwn) {
        // Own Bio
        self.bioTextView = [[UITextView alloc] initWithFrame:CGRectMake(16.0f, self.avatarImageView.maxY + 56.0f, self.view.width - 32.0f, IS_IPHONE5_OR_OLDER ? 106.0f : 116.0f)];
        self.bioTextView.backgroundColor = [UIColor clearColor];
        self.bioTextView.font = [PTKFont regularFontOfSize:IS_IPHONE5_OR_OLDER ? 13.0f : 14.0f];
        self.bioTextView.textColor = [PTKColor almostBlackColor];
        self.bioTextView.textContainer.maximumNumberOfLines = 3;
        self.bioTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        self.bioTextView.textAlignment = NSTextAlignmentCenter;
        self.bioTextView.delegate = self;
        self.bioTextView.alpha = 0;
        [self.bioTextView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
        [self.bioTextView setText:@" "];
        [self.view addSubview:self.bioTextView];

        // Empty Bio Placeholder
        self.bioPlaceholderView = [[UIView alloc] initWithFrame:self.bioTextView.frame];
        self.bioPlaceholderView.userInteractionEnabled = NO;
        self.bioPlaceholderView.alpha = 0;
        [self.view addSubview:self.bioPlaceholderView];

        PTKImageView* pencilImageView = [[PTKImageView alloc] initWithFrame:CGRectMake(ceilcg(self.view.width / 2.0f) - 58.0f, ceilcg(self.bioPlaceholderView.height / 2.0f) - 9.0f, 18.0f, 18.0f)];
        pencilImageView.image = [[UIImage imageNamed:@"ic_mode_edit"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        pencilImageView.tintColor = [PTKColor grayColor];
        [self.bioPlaceholderView addSubview:pencilImageView];

        UILabel* bioLabel = [[UILabel alloc] initWithFrame:CGRectMake(pencilImageView.maxX + 10.0f, pencilImageView.frame.origin.y - 1.0f, ceilcg(self.view.width / 2.0f), 20.0f)];
        bioLabel.font = [PTKFont mediumFontOfSize:16.0f];
        bioLabel.textColor = [PTKColor grayColor];
        bioLabel.text = localizedString(@"Add bio");
        [self.bioPlaceholderView addSubview:bioLabel];
    } else {
        // User Bio
        self.bioLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, self.avatarImageView.maxY + 45.0f, self.view.width - 32.0f, IS_IPHONE5_OR_OLDER ? 60.0f : 80.0f)];
        self.bioLabel.textAlignment = NSTextAlignmentCenter;
        self.bioLabel.numberOfLines = 3;
        self.bioLabel.font = [PTKFont regularFontOfSize:IS_IPHONE5_OR_OLDER ? 13.0f : 14.0f];
        self.bioLabel.textColor = [PTKColor profileBlackTextColor];
        self.bioLabel.minimumScaleFactor = 0.5f;
        self.bioLabel.adjustsFontSizeToFitWidth = YES;
        self.bioLabel.alpha = 0;
        [self.view addSubview:self.bioLabel];

        // Action Button
        self.actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.actionButton.frame = CGRectMake(self.view.midX - 123.0f, self.bioLabel.maxY, 246.0f, 36.0f);
        self.actionButton.backgroundColor = [PTKColor brandColor];
        self.actionButton.titleLabel.font = [PTKFont boldFontOfSize:15.0f];
        self.actionButton.showsTouchWhenHighlighted = YES;
        self.actionButton.layer.masksToBounds = YES;
        self.actionButton.layer.cornerRadius = 18.0f;
        self.actionButton.layer.shouldRasterize = YES;
        self.actionButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.actionButton.alpha = 0;
        [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.actionButton addTarget:self action:@selector(actionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.actionButton];
    }

    // "Featured Rooms"
    self.featuredRoomsLabel = [[PTKLineLabel alloc] initWithFrame:CGRectMake(0, self.view.height - self.bottomLayoutGuide.length - 220.0f, self.view.width, 20.0f)];
    self.featuredRoomsLabel.backgroundColor = [UIColor clearColor];
    self.featuredRoomsLabel.font = [PTKFont boldFontOfSize:12.0f];
    self.featuredRoomsLabel.textColor = [PTKColor grayColor];
    self.featuredRoomsLabel.attributedText = [[NSAttributedString alloc] initWithString:localizedString(@"FEATURED ROOMS") attributes:@{NSKernAttributeName: @(2)}];
    self.featuredRoomsLabel.lineMargin = 10.0f;
    self.featuredRoomsLabel.alpha = 0;
    [self.view addSubview:self.featuredRoomsLabel];

    if (self.viewType == PTKProfileViewTypeNormal) {
        // No Featured Rooms Image
        self.featuredEmptyImage = [[PTKImageView alloc] initWithFrame:CGRectMake(ceilcg(self.view.midX - 200.0f / 2.0f), self.view.height - self.bottomLayoutGuide.length - 200.0f, 200.0f, 60.0f)];
        self.featuredEmptyImage.contentMode = UIViewContentModeScaleAspectFit;
        self.featuredEmptyImage.image = [UIImage imageNamed:@"empty_features_graphic"];
        self.featuredEmptyImage.alpha = 0;
        [self.view addSubview:self.featuredEmptyImage];

        // No Featured Rooms Label
        self.featuredEmptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.featuredEmptyImage.maxY, self.view.width, 80.0f)];
        self.featuredEmptyLabel.numberOfLines = 3;
        self.featuredEmptyLabel.font = [PTKFont regularFontOfSize:14.0f];
        self.featuredEmptyLabel.textColor = [PTKColor grayColor];
        self.featuredEmptyLabel.textAlignment = NSTextAlignmentCenter;
        self.featuredEmptyLabel.alpha = 0;
        [self.view addSubview:self.featuredEmptyLabel];
    }

    CGFloat width = floorcg(([UIScreen mainScreen].bounds.size.width - (kUPVRoomCellMargin * 3.0f)) / 2.0f);
    self.featuredCellSize = CGSizeMake(width, [PTKRoomCollectionViewCell heightForRoom:nil withWidth:width]);

    PTKPagingLayout *pagingLayout = [[PTKPagingLayout alloc] init];
    pagingLayout.cellSize = self.featuredCellSize;
    pagingLayout.delegate = self;

    // Featured Rooms
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.height - self.bottomLayoutGuide.length - self.featuredCellSize.height - 20.0f, self.view.width, self.featuredCellSize.height + 20.0f) collectionViewLayout:pagingLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollEnabled = YES;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alpha = 0;
    [self.collectionView registerClass:[PTKRoomCollectionViewCell class] forCellWithReuseIdentifier:kUPVRoomCellIdentifier];
    [self.collectionView registerClass:[PTKRoomAddCollectionViewCell class] forCellWithReuseIdentifier:kUPVRoomAddCellIdentifier];
    [self.view addSubview:self.collectionView];

    // Activity Indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.center = self.view.midPoint;
    [self.activityIndicator startAnimating];
    [self.view addSubview:self.activityIndicator];

    [self showDefaultNavBar];
}

- (void)updateViewForDisplay {
    [self updateBasicProfile];
    [self updateUserBio];
    [self updateStatusText];
    [self updateFriendCount];
    [self updateRoomCount];
    [self updateActionButton];
    [self updateFeaturedRooms];

    [self animateProfileIntoView];
}

- (void)animateProfileIntoView {
    if ([self isUserBlocked] && !self.avatarBlurView) {
        self.avatarBlurView = [[FXBlurView alloc] initWithFrame:self.avatarImageView.bounds];
        self.avatarBlurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.avatarBlurView.blurRadius = 8.0f;
        self.avatarBlurView.tintColor = [UIColor clearColor];
        [self.avatarImageView addSubview:self.avatarBlurView];
    }

    WEAK_SELF
    [UIView animateWithDuration:0.3f animations:^{
        STRONG_SELF

        if ([self isUserBlocked]) {
            self.friendCountLabel.alpha = 1.0f;
            self.friendsLabel.alpha = 1.0f;
            self.roomCountLabel.alpha = 1.0f;
            self.roomsLabel.alpha = 1.0f;
            self.statusTitleLabel.alpha = 0;
            self.shareButton.alpha = 0;
            self.statusTextLabel.alpha = 0;
            self.bioTextView.alpha = 0;
            self.bioLabel.alpha = 0;
            self.actionButton.alpha = 1.0f;
            self.featuredRoomsLabel.alpha = 0;
            self.featuredEmptyImage.alpha = 0;
            self.featuredEmptyLabel.alpha = 0;
            self.collectionView.alpha = 0;
            self.usernameLabel.textColor = [PTKColor grayColor];
        } else {
            if (self.avatarBlurView) {
                [self.avatarBlurView removeFromSuperview];
                self.avatarBlurView = nil;
            }

            self.friendCountLabel.alpha = 1.0f;
            self.friendsLabel.alpha = 1.0f;
            self.roomCountLabel.alpha = 1.0f;
            self.roomsLabel.alpha = 1.0f;
            self.statusTitleLabel.alpha = 1.0f;
            self.shareButton.alpha = 1.0f;
            self.statusTextLabel.alpha = 1.0f;
            self.bioTextView.alpha = 1.0f;
            self.bioLabel.alpha = 1.0f;
            self.actionButton.alpha = 1.0f;
            self.featuredRoomsLabel.alpha = 1.0f;
            self.featuredEmptyImage.alpha = 1.0f;
            self.featuredEmptyLabel.alpha = 1.0f;
            self.collectionView.alpha = 1.0f;
            self.usernameLabel.textColor = [PTKColor brandColor];
        }

        [self.activityIndicator stopAnimating];
    }];
}

#pragma mark -

- (void)updateBasicProfile {
    self.titleLabel.text = self.user.fullName;
    [self.titleLabel sizeToFit];

    [self.avatarImageView setImageWithAvatarForUserId:self.user.userId size:self.avatarImageView.bounds.size];

    NSString *username = self.user.username;
    if (!EMPTY_STR(username)) {
        self.usernameLabel.text = [NSString stringWithFormat:@"@%@", username];
        self.usernameLabel.hidden = NO;

        CGSize size = [self.usernameLabel sizeThatFits:CGSizeMake(self.view.width - 32.0f, 18.0f)];
        size.width = ceilcg(size.width) + 12.0f;
        self.usernameLabel.frame = CGRectMake(ceilcg(self.view.width / 2.0f) - ceilcg(size.width / 2.0f), self.avatarImageView.maxY - 23.0f, size.width, 18.0f);
    } else {
        self.usernameLabel.hidden = YES;
    }
}

- (void)updateUserBio {
    NSString *bio = self.user.bio;
    if (bio.length > kUPVMaxBioLength) bio = [NSString stringWithFormat:@"%@…", [bio substringWithRange:NSMakeRange(0, kUPVMaxBioLength)]];

    if (self.viewType == PTKProfileViewTypeOwn) {
        if (!EMPTY_STR(bio)) {
            self.bioTextView.text = bio;
            self.bioPlaceholderView.alpha = 0;
        } else {
            self.bioTextView.text = nil;
            self.bioPlaceholderView.alpha = 0.7f;
        }
    } else {
        if (!EMPTY_STR(bio)) {
            self.bioLabel.text = bio;
        } else {
            self.bioLabel.text = [NSString stringWithFormat:@"%@ doesn’t have a bio 😢", self.user.firstName];
        }
    }
}

- (void)updateStatusText {
    self.roomUserIsIn = nil;

    if (self.viewType == PTKProfileViewTypeOwn) {
        self.statusTitleLabel.text = localizedString(@"SHARE USERNAME");
        self.statusTextLabel.userInteractionEnabled = NO;
        self.statusTextLabel.text = nil;
        self.shareButton.hidden = NO;
    } else {
        BOOL isFriend = [self.friendsDataSource isMutualFriendWithUserId:self.user.oid];
        self.shareButton.hidden = YES;

        if (isFriend && [self.onlinePresence isUserOnline:self.user.oid]) {
            NSString *roomId = [self.onlinePresence roomIdForUser:self.user.userId];

            if (roomId) {
                self.statusTitleLabel.text = localizedString(@"CURRENTLY IN");

                PTKRoom *room = [PTKOnlinePresenceDataSource roomForRoomId:roomId];
                NSString *roomDisplayName = nil;
                UIColor *roomColor = nil;

                if (room) {
                    self.roomUserIsIn = room;
                    roomDisplayName = (room.is1on1 ? @"Your 1-on-1 Room" : room.roomDisplayName);
                    roomColor = room.roomColor;
                }

                if (!EMPTY_STR(roomDisplayName)) {
                    NSString *messageString = [NSString stringWithFormat:NSLocalizedString(@"%@ \u276F", 0), roomDisplayName];
                    self.statusTextLabel.textColor = [roomColor readableColor];
                    self.statusTextLabel.text = messageString;
                    self.statusTextLabel.userInteractionEnabled = YES;
                } else {
                    self.statusTextLabel.textColor = [PTKColor brandColor];
                    self.statusTextLabel.text = NSLocalizedString(@"A Private Room", 0);
                    self.statusTextLabel.userInteractionEnabled = NO;
                }
            } else {
                self.statusTitleLabel.text = localizedString(@"LAST SEEN");
                self.statusTextLabel.textColor = [PTKColor greenActionColor];
                self.statusTextLabel.text = NSLocalizedString(@"Online Now", 0);
                self.statusTextLabel.userInteractionEnabled = NO;
            }
        } else if (isFriend) {
            self.statusTitleLabel.text = localizedString(@"LAST SEEN");
            self.statusTextLabel.textColor = [PTKColor grayColor];
            self.statusTextLabel.userInteractionEnabled = NO;

            if (!NILORNULL(self.user.lastSeenAt)) {
                self.statusTextLabel.text = [PTKDatetimeUtility formattedIntervalSinceDate:self.user.lastSeenAt now:localizedString(@"Just Now") suffix:localizedString(@"ago")];
            } else {
                self.statusTextLabel.text = localizedString(@"Away");
            }
        } else {
            self.statusTitleLabel.text = localizedString(@"FRIENDS WITH");
            self.statusTextLabel.textColor = [PTKColor grayColor];
            self.statusTextLabel.userInteractionEnabled = NO;

            NSUInteger count = self.mutualFriends.count;

            if (count == 1) {
                self.statusTextLabel.text = [self.mutualFriends[0] valueForKey:@"firstName"];
            } else if (count == 2) {
                self.statusTextLabel.text = [NSString stringWithFormat:@"%@ and %@", [self.mutualFriends[0] valueForKey:@"firstName"], [self.mutualFriends[1] valueForKey:@"firstName"]];
            } else if (count == 3) {
                self.statusTextLabel.text = [NSString stringWithFormat:@"%@, %@ and %@", [self.mutualFriends[0] valueForKey:@"firstName"], [self.mutualFriends[1] valueForKey:@"firstName"], [self.mutualFriends[2] valueForKey:@"firstName"]];
            } else if (count > 3) {
                self.statusTextLabel.text = [NSString stringWithFormat:@"%@, %@ + %d others", [self.mutualFriends[0] valueForKey:@"firstName"], [self.mutualFriends[1] valueForKey:@"firstName"], (int)count - 2];
            } else {
                self.statusTextLabel.text = localizedString(@"No Mutual Friends");
            }
        }
    }
}

- (void)updateFriendCount {
    self.friendCountLabel.text = [NSString stringWithFormat:@"%d", self.totalFriends];

    BOOL isFriend = [self.friendsDataSource isMutualFriendWithUserId:self.user.oid];
    if (self.viewType == PTKProfileViewTypeOwn) isFriend = YES;

    if ((isFriend || !self.user.privateProfile) && ![self isUserBlocked]) {
        self.friendCountLabel.textColor = [PTKColor brandColor];
        self.friendsButton.enabled = YES;
    } else {
        self.friendCountLabel.textColor = self.friendsLabel.textColor;
        self.friendsButton.enabled = NO;
    }
}

- (void)updateRoomCount {
    int total = self.totalPublicRooms + self.totalSharedRooms;

    if (self.sharedRooms.count > 0) {
        NSMutableSet *rooms = [NSMutableSet setWithArray:self.publicRooms];
        [rooms intersectSet:[NSSet setWithArray:self.sharedRooms]];
        total -= rooms.count;
    }

    self.roomCountLabel.text = [NSString stringWithFormat:@"%d", total];

    BOOL isFriend = [self.friendsDataSource isMutualFriendWithUserId:self.user.oid];
    if (self.viewType == PTKProfileViewTypeOwn) isFriend = YES;

    if ((isFriend || !self.user.privateProfile) && ![self isUserBlocked]) {
        self.roomCountLabel.textColor = [PTKColor brandColor];
        self.roomsButton.enabled = YES;
    } else {
        self.roomCountLabel.textColor = self.roomsLabel.textColor;
        self.roomsButton.enabled = NO;
    }
}

- (void)updateActionButton {
    if ([self isUserBlocked]) {
        [self.actionButton setTitle:localizedString(@"BLOCKED USER") forState:UIControlStateNormal];
        [self.actionButton setTitleColor:[PTKColor almostWhiteColor] forState:UIControlStateNormal];
        [self.actionButton setBackgroundColor:[PTKColor redActionColor]];
    } else if ([self.friendsDataSource hasOutgoingRequestForUserId:self.user.oid]) {
        [self.actionButton setTitle:localizedString(@"FRIEND REQUEST SENT") forState:UIControlStateNormal];
        [self.actionButton setTitleColor:[PTKColor brandColor] forState:UIControlStateNormal];
        [self.actionButton setBackgroundColor:[PTKColor almostWhiteColor]];
    } else if ([self.friendsDataSource hasIncomingRequestForUserId:self.user.oid]) {
        [self.actionButton setTitle:localizedString(@"ACCEPT FRIEND REQUEST") forState:UIControlStateNormal];
        [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.actionButton setBackgroundColor:[PTKColor brandColor]];
    } else if ([self.friendsDataSource isMutualFriendWithUserId:self.user.oid]) {
        [self.actionButton setTitle:localizedString(@"ENTER 1:1 ROOM") forState:UIControlStateNormal];
        [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.actionButton setBackgroundColor:[PTKColor brandColor]];
    } else {
        [self.actionButton setTitle:localizedString(@"ADD FRIEND") forState:UIControlStateNormal];
        [self.actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.actionButton setBackgroundColor:[PTKColor brandColor]];
    }
}

- (void)updateFeaturedRooms {
    BOOL isFriend = [self.friendsDataSource isMutualFriendWithUserId:self.user.oid];
    if (self.viewType == PTKProfileViewTypeOwn) isFriend = YES;

    if (!isFriend && self.user.privateProfile) {
        self.featuredEmptyLabel.text = [NSString stringWithFormat:localizedString(@"%@'s profile is private.\nBecome friends to see featured rooms,\npublic rooms, and friends."), self.user.firstName];
        self.featuredEmptyImage.hidden = NO;
        self.featuredEmptyLabel.hidden = NO;
        self.collectionView.hidden = YES;
    } else if (self.viewType == PTKProfileViewTypeNormal && self.featuredRooms.count == 0) {
        self.featuredEmptyLabel.text = [NSString stringWithFormat:localizedString(@"%@ hasn't featured any rooms yet 😢"), self.user.firstName];
        self.featuredEmptyImage.hidden = NO;
        self.featuredEmptyLabel.hidden = NO;
        self.collectionView.hidden = YES;
    } else {
        self.featuredEmptyImage.hidden = YES;
        self.featuredEmptyLabel.hidden = YES;
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];

        WEAK_SELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            STRONG_SELF

            if (self.viewType == PTKProfileViewTypeNormal && self.featuredRooms.count > 2) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            } else if (self.viewType == PTKProfileViewTypeOwn) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            }
        });
    }
}

#pragma mark - Navigation

- (void)showCancelAndDoneNavBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBioButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBioButtonAction:)];
    self.navigationItem.leftBarButtonItem.tintColor = [PTKColor almostBlackColor];
    self.navigationItem.rightBarButtonItem.tintColor = [PTKColor almostBlackColor];
}

- (void)showDefaultNavBar {
    if (self.viewType == PTKProfileViewTypeOwn) {
        if (self.presentingViewController || self.navigationController.viewControllers.count > 1) {
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[[PTKGraphics navigationBackImageWithColor:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(backButtonAction:)];
            self.navigationItem.leftBarButtonItem = backButton;
        } else {
            self.navigationItem.leftBarButtonItem = nil;
        }

        UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"swipe_settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(settingsButtonAction:)];
        self.navigationItem.rightBarButtonItem = settingsButton;
    } else {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[[PTKGraphics navigationBackImageWithColor:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(backButtonAction:)];
        self.navigationItem.leftBarButtonItem = backButton;

        if (![self.user.oid isEqualToString:SELF_ID()]) {
            UIBarButtonItem *optionsButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"options"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(optionsButtonAction:)];
            self.navigationItem.rightBarButtonItem = optionsButton;
        }
    }

    self.navigationItem.leftBarButtonItem.tintColor = [PTKColor almostBlackColor];
    self.navigationItem.rightBarButtonItem.tintColor = [PTKColor almostBlackColor];
}


@end
