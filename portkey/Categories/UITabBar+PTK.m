//
//  UITabBar+PTK.m
//  portkey
//
//  Created by Daniel Amitay on 11/20/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

#import "UITabBar+PTK.h"
#import <objc/runtime.h>

static CGFloat kBadgeDiameter = 18.0f;
static CGFloat kBadgeDiameterSmall = 12.0f;

@interface PTKTabBarOverlay : UIView {
    NSMutableDictionary *_valuesForIndex;
    NSMutableDictionary *_colorsForIndex;
}

@property (nonatomic, weak) UITabBar *tabBar;
@property (nonatomic, strong) NSArray *labels;

@end

@implementation PTKTabBarOverlay

#pragma mark - Lifecycle methods

- (id)initWithTabBar:(UITabBar *)tabBar {
    self = [super initWithFrame:tabBar.bounds];
    if (self) {
        _valuesForIndex = [[NSMutableDictionary alloc] init];
        _colorsForIndex = [[NSMutableDictionary alloc] init];

        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.userInteractionEnabled = NO;

        self.tabBar = tabBar;
        [self updateItemsCount];
    }
    return self;
}

#pragma mark - Layout methods

- (void)layoutSubviews {
    [super layoutSubviews];

    [self updateItemsCount];

    [self.superview bringSubviewToFront:self];

    NSInteger labelCount = self.labels.count;
    CGFloat labelAreaWidth = self.bounds.size.width / labelCount;
    for (NSInteger i = 0; i < self.labels.count; i++) {
        UILabel *label = [self.labels objectAtIndex:i];
        if (label.hidden) {
            continue;
        }

        CGSize labelSize = CGSizeMake(kBadgeDiameterSmall, kBadgeDiameterSmall);
        CGSize centerOffset = CGSizeMake(16.0f, -11.0f);
        if (label.text.length) {
            labelSize = [label sizeThatFits:label.bounds.size];
            labelSize = [PTKGraphics ceiledSize:labelSize];
            labelSize.width = MAX(kBadgeDiameter, labelSize.width + 8.0f);
            labelSize.height = kBadgeDiameter;
        } else {
            centerOffset = CGSizeMake(15.0f, -12.0f);
        }

        label.bounds = (CGRect) {
            .size = labelSize
        };
        label.layer.cornerRadius = labelSize.height / 2.0f;
        label.center = (CGPoint) {
            .x = (labelAreaWidth / 2.0f) + labelAreaWidth * i + centerOffset.width,
            .y = self.bounds.size.height / 2.0f + centerOffset.height
        };
    }
}


#pragma mark - Public methods

- (void)setColor:(UIColor *)color forBadgeAtIndex:(NSInteger)index {
    NSNumber *indexNumber = [NSNumber numberWithInteger:index];
    if (color) {
        [_colorsForIndex setObject:color forKey:indexNumber];
    } else {
        [_colorsForIndex removeObjectForKey:indexNumber];
    }

    if (index < self.labels.count) {
        UILabel *label = [self.labels objectAtIndex:index];
        label.backgroundColor = color;
        [self setNeedsLayout];
    }
}

- (UIColor *)colorForBadgeAtIndex:(NSInteger)index {
    NSNumber *indexNumber = [NSNumber numberWithInteger:index];
    UIColor *color = [_colorsForIndex objectForKey:indexNumber];
    return color ?: [PTKColor redActionColor];
}

- (void)setValue:(NSString *)value forBadgeAtIndex:(NSInteger)index {
    NSNumber *indexNumber = [NSNumber numberWithInteger:index];
    if (value) {
        [_valuesForIndex setObject:value forKey:indexNumber];
    } else {
        [_valuesForIndex removeObjectForKey:indexNumber];
    }

    if (index < self.labels.count) {
        UILabel *label = [self.labels objectAtIndex:index];
        label.text = value;
        label.hidden = NILORNULL(value);
        [self setNeedsLayout];
    }
}

- (NSString *)valueForBadgeAtIndex:(NSInteger)index {
    NSNumber *indexNumber = [NSNumber numberWithInteger:index];
    return [_valuesForIndex objectForKey:indexNumber];
}


#pragma mark - Internal logic methods

- (void)updateItemsCount {
    [self.labels makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSMutableArray *labels = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.tabBar.items.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [PTKColor almostWhiteColor];
        label.font = [PTKFont regularFontOfSize:14.0f];
        label.backgroundColor = [self colorForBadgeAtIndex:i];
        label.text = [self valueForBadgeAtIndex:i];
        label.hidden = NILORNULL(label.text);
        label.layer.masksToBounds = YES;
        [labels addObject:label];
        [self addSubview:label];
    }
    self.labels = labels;
}

@end

static char const * const OverlayTagKey = "OverlayTag";

@interface UITabBar (PTK_Internal)

@property (nonatomic, strong) PTKTabBarOverlay *overlay;

@end


@implementation UITabBar (PTK)

#pragma mark - Public methods

- (void)enableCustomTabBar {
    if (self.overlay == nil) {
        self.overlay = [[PTKTabBarOverlay alloc] initWithTabBar:self];
        [self addSubview:self.overlay];
    }
}

- (void)setColor:(UIColor *)color forBadgeAtIndex:(NSInteger)index {
    [self enableCustomTabBar];
    [self.overlay setColor:color forBadgeAtIndex:index];
}

- (UIColor *)colorForBadgeAtIndex:(NSInteger)index {
    return [self.overlay colorForBadgeAtIndex:index];
}

- (void)setValue:(NSString *)value forBadgeAtIndex:(NSInteger)index {
    [self enableCustomTabBar];
    [self.overlay setValue:value forBadgeAtIndex:index];
}

- (NSString *)valueForBadgeAtIndex:(NSInteger)index {
    return [self.overlay valueForBadgeAtIndex:index];
}


#pragma mark - PTKTabBarOverlay methods

- (PTKTabBarOverlay *)overlay {
    return objc_getAssociatedObject(self, OverlayTagKey);
}

- (void)setOverlay:(PTKTabBarOverlay *)overlay {
    objc_setAssociatedObject(self, OverlayTagKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
