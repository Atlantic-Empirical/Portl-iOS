//
//  PTKRoomCardView.m
//  portkey
//
//  Created by Robert Reeves on 3/25/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import "PTKCardView.h"
#import "PTKRecommendedRoom.h"
#import "PTKAvatarCircles.h"



@interface PTKCardView ()

@property (nonatomic) UIView* cardView;
@property (nonatomic) CAGradientLayer* colorGradientLayer;

@property (nonatomic) UIView* headerView;
@property (nonatomic) UILabel* titleLabel;
@property (nonatomic) UILabel* privateLabel;
@property (nonatomic) UILabel* detailLabel;


/**
 if set, will override card's user or room background color
 */
@property (nonatomic) UIColor* masterColor;

@end



@implementation PTKCardView


#pragma mark - init

- (id)initWithFrame:(CGRect)frame withMasterCardColor:(UIColor*)color {
    
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    
    // if set, will override card's user or room background color
    _masterColor = color;
    
    
    // card container view
    _cardView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_cardView];
    
    
    // background color gradient, updated after init
    _colorGradientLayer = [CAGradientLayer layer];
    _colorGradientLayer.frame = _cardView.bounds;
    _colorGradientLayer.colors = nil;
    _colorGradientLayer.startPoint = CGPointMake(1.0, 0.5);
    _colorGradientLayer.endPoint = CGPointMake(0.0, 0.5);
    _cardView.layer.masksToBounds = true;
    [_cardView.layer addSublayer:_colorGradientLayer];
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOpacity:0.4f];
    [self.layer setShadowRadius:2.0f];
    [self.layer setShadowOffset:CGSizeMake(0.0f, 2.0f)];
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = UIScreen.mainScreen.scale;
    _cardView.layer.borderWidth = 1.0f;
    _cardView.layer.cornerRadius = 5.0f;
    _cardView.clipsToBounds = YES;
    
    
    // darkened rectangle header at the top of card, container title
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _cardView.width, 33.0f)];
    _headerView.backgroundColor = [[PTKColor almostBlackColor] colorWithAlphaComponent:0.1f];
    [_cardView addSubview:_headerView];
    
    // title label in card header
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 1;
    _titleLabel.frame = CGRectMake(0, 0, _cardView.width, _headerView.bounds.size.height);
    _titleLabel.textColor = [PTKColor almostWhiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_cardView addSubview:_titleLabel];
    
    
    // "UserA, UserB and UserC are members"
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, _cardView.height-55.0f, _cardView.width-20.0f, 44.0f)];
    _detailLabel.textColor = [PTKColor almostWhiteColor];
    _detailLabel.adjustsFontSizeToFitWidth = YES;
    _detailLabel.font = [PTKFont italicFontWithSize:14.0f];
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.numberOfLines = 2;
    [_cardView addSubview:_detailLabel];
    
    
    return self;
}

- (void)updateViewWithObject:(id)object {
    
    if ([object isKindOfClass:[PTKUser class]]) {
        
        self.user = (PTKUser*)object;
    }
    else if ([object isKindOfClass:[PTKRecommendedRoom class]]) {
        
        PTKRecommendedRoom* rec = (PTKRecommendedRoom*)object;
        self.room = rec.room;
    }
    else if ([object isKindOfClass:[PTKRoom class]]) {
        
        self.room = (PTKRoom*)object;
    }
    else {
        // only PTKUser & PTKRoom are currently supported
        return;
    }
    
    [self setupCardBorderColor];
    
    [self setupAvatarCircleView];
    
    [self setupBlackOverlayView];
}



#pragma mark - set content

/**
 returns members copy for the bottom of room card views
 @param PTKRoom the room object for the room card
 @return NSString formatted members copy for a label
 */
- (NSString*)memberTextForCardWithRoom:(PTKRoom*)room {
    
    // "UserA, UserB and User C are members"
    
    NSString* text = @"";
    
    int idx = 0;
    int maxCount = 4;
    
    NSArray *featured = room.featured;
    NSArray *subArray = [featured subarrayWithRange:NSMakeRange(0, MIN(4, featured.count))];
    
    for (PTKUser *user in subArray) {
        if (idx == maxCount)
            break;
        
        BOOL lastNext = (idx+2 == subArray.count);
        BOOL last = (idx+1 == subArray.count);
        NSString* nextText = (lastNext) ? @" and " : (last) ? @"" : @", ";
        text = [text stringByAppendingString:[NSString stringWithFormat:@"%@%@", user.fullName, nextText]];
        idx++;
    }
    
    text = [text stringByAppendingString:[NSString stringWithFormat:@"%@", (subArray.count > 1) ? @" are members" : @" is a member"]];
    
    return text;
}


/**
 updates the PTKCardView to show a single user askign for acceptance
 @param PTKUser to build the view
 */
- (void)setUser:(PTKUser *)user {
    
    if (![user isKindOfClass:[PTKUser class]])
        return;
    
    _user = user;
    
    
    UIColor* backColor = (self.masterColor) ? self.masterColor : [PTKColor brandColor];
    _colorGradientLayer.colors = [PTKColor gradientColorsForColor:backColor];
    self.layer.borderColor = backColor.CGColor;
    
    _titleLabel.font = [PTKFont mediumFontOfSize:19.0f];
    _titleLabel.text = self.user.firstName;
    
    _detailLabel.text = localizedString(@"is requesting access");
}


/**
 updates the PTKCardView to show room meta data including featured users
 @param PTKRoom to build the view
 */
- (void)setRoom:(PTKRoom *)room {
    
    if (![room isKindOfClass:[PTKRoom class]])
        return;
    
    _room = room;
    
    
    UIColor* backColor = (self.masterColor) ? self.masterColor : self.room.roomColor;
    _colorGradientLayer.colors = [PTKColor gradientColorsForColor:backColor];
    self.layer.borderColor = backColor.CGColor;
    
    
    _titleLabel.font = self.room.is1on1 ?  [PTKFont mediumFontOfSize:24.0f] :  [PTKFont mediumFontOfSize:19.0f];
    _titleLabel.text = self.room.is1on1 && EMPTY_STR(self.room.title) ? localizedString(@"1-on-1 room") : self.room.roomDisplayName;
    _detailLabel.text = self.room.is1on1 ? @"" : [self memberTextForCardWithRoom:self.room];
    
    
    if (self.room.pending) {
        [self setupPendingInvitedView];
    }
    
    
    if ([self.room isPrivate]) {
        _privateLabel = [[UILabel alloc] init];
        _privateLabel.text = localizedString(@"Private");
        _privateLabel.font = [PTKFont regularFontOfSize:12.0f];
        
        CGSize privateLabelSize = [_privateLabel sizeThatFits:_cardView.frame.size];
        _privateLabel.frame = CGRectMake((_headerView.width-privateLabelSize.width)/2.0f, CGRectGetMaxY(_titleLabel.frame)+((self.room.pending) ? 5.0f : 12.0f), privateLabelSize.width, privateLabelSize.height);
        _privateLabel.textAlignment = NSTextAlignmentCenter;
        _privateLabel.textColor = [PTKColor almostWhiteColor];
        [_cardView addSubview:_privateLabel];
        
        PTKImageView* lockImage = [[PTKImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_privateLabel.frame)+3.0f, CGRectGetMidY(_privateLabel.frame)-6.0f, 12.0f, 12.0f)];
        [lockImage setImage:[UIImage imageNamed:@"ic_lock_14x"]];
        [self addSubview:lockImage];
    }
}



#pragma mark - pending header

/**
 sets up a label and header view for additional text & profile image
 displays info for the user intiiating the invite used for the card
 */
- (void)setupPendingInvitedView {
    
    PTKImageView* userProfileImage = [[PTKImageView alloc] initWithFrame:CGRectMake(10.0f, -22.0f, 44.0f, 44.0f)];
    userProfileImage.clipsToBounds = YES;
    [self addSubview:userProfileImage];
    CGFloat size = 44.0f;
    [userProfileImage setImageWithAvatarForUserId:self.room.inviter.userId size:CGSizeMake(size, size)];
    
    
    // bump the title down to make room for the inviteLabel
    _titleLabel.frame =  CGRectMake(_titleLabel.frame.origin.x, self.room.is1on1 ? _headerView.bounds.size.height*2 : _headerView.bounds.size.height, _titleLabel.bounds.size.width, _titleLabel.bounds.size.height);
    
    
    [self setupInvitedLabelInHeader];
}

- (void)setupInvitedLabelInHeader {
    
    UILabel* invitedLabel = [[UILabel alloc] init];
    invitedLabel.textColor = [PTKColor almostWhiteColor];
    invitedLabel.textAlignment = NSTextAlignmentCenter;
    invitedLabel.font = [PTKFont mediumFontOfSize:18.0f];
    if (!EMPTY_STR(self.room.inviter.firstName)) {
        invitedLabel.text = [NSString stringWithFormat:localizedString(@"%@ Invited You!"), self.room.inviter.firstName];
    }
    else {
        invitedLabel.text = localizedString(@"You were invited!");
    }
    CGSize invitedSize = [invitedLabel.text sizeWithAttributes:@{NSFontAttributeName : invitedLabel.font}];
    if (invitedSize.width <= _headerView.width - 120.0f) {
        invitedLabel.frame = _headerView.bounds;
    }
    else {
        invitedLabel.frame = (CGRect){
            .origin.x = 60.0f,
            .origin.y = 0.0f,
            .size.width = _headerView.width - 70.0f,
            .size.height = _headerView.height
        };
        invitedLabel.textAlignment = NSTextAlignmentLeft;
        invitedLabel.numberOfLines = 0;
        invitedLabel.adjustsFontSizeToFitWidth = true;
        invitedLabel.minimumScaleFactor = 10.0f / 18.0f;
    }
    
    [_headerView addSubview:invitedLabel];
}



#pragma mark - ui setup

/**
 sets up the avatar circle view, based on room or user objects
 positioned between the title, public & detail labels
 */
- (void)setupAvatarCircleView {
    
    CGFloat circleYPoint;
    if (!NILORNULL(self.room)) {
        
        circleYPoint = ([self.room isPrivate]) ? CGRectGetMaxY(self.privateLabel.frame) : CGRectGetMaxY(self.titleLabel.frame);
    }
    else {
        
        circleYPoint = CGRectGetMidY(_cardView.bounds)-((_cardView.bounds.size.height * 0.6f) / 2.0f);
    }
    circleYPoint += 10.0f;
    CGFloat circleHeight;
    if (!NILORNULL(self.room)) {
        
        if ([self.room isPrivate]) {
            circleHeight = _cardView.height-CGRectGetMaxY(self.privateLabel.frame);
        }
        else {
            circleHeight = _cardView.height-CGRectGetMaxY(self.titleLabel.frame);
        }
        circleHeight -= self.detailLabel.height*1.5;
    } else {
        circleHeight = _cardView.bounds.size.height * 0.6f;
    }
    
    
    NSMutableArray *users;
    if (!NILORNULL(self.room)) {
        
        users = [NSMutableArray arrayWithArray:self.room.featured];
    }
    else {
        users = [NSMutableArray arrayWithObject:self.user];
    }
    
    PTKAvatarCircles* avCircleView = [[PTKAvatarCircles alloc] initWithFrame:CGRectMake(CGRectGetMidX(_cardView.bounds)-(circleHeight/2), circleYPoint, circleHeight, circleHeight)];
    [avCircleView updateWithUsers:users animated:NO];
    avCircleView.clipsToBounds = YES;
    [_cardView addSubview:avCircleView];
}


/**
 sets up a black overlay view that fades in as the user taps-drags a card 
 to commit to a decline or accept action
 */
- (void)setupBlackOverlayView {
    
    self.blackOverlayView = [[UIView alloc] initWithFrame:_cardView.bounds];
    self.blackOverlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    self.blackOverlayView.alpha = 0;
    [_cardView addSubview:self.blackOverlayView];
    self.statusImage = [[PTKImageView alloc] initWithFrame:CGRectMake(0, 0, 22.0f, 22.0f)];
    self.statusImage.center = _cardView.center;
    [self.statusImage setImage:[PTKGraphics xImageWithColor:[PTKColor almostWhiteColor] backgroundColor:[UIColor clearColor] size:CGSizeMake(22.0f, 22.0f) lineWidth:2.0f]];
    [self.blackOverlayView addSubview:self.statusImage];
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.statusImage.frame), self.blackOverlayView.width, 44.0f)];
    self.statusLabel.text = localizedString(@"DECLINE");
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [PTKFont boldFontOfSize:16.0f];
    self.statusLabel.textColor = [PTKColor almostWhiteColor];
    [self.blackOverlayView addSubview:self.statusLabel];
}

- (void)setupCardBorderColor {
    
    if (!self.room && !NILORNULL(self.masterColor)) {
        
        _cardView.layer.borderColor = _masterColor.CGColor;
    }
    else if (self.room) {
        _cardView.layer.borderColor = _room.roomColor.CGColor;
    }
}




@end
