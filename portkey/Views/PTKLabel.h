//
//  PTKLabel.h
//  portkey
//
//  Created by Rodrigo Sieiro on 18/9/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTKLabel;
@protocol PTKLabelDelegate <NSObject>

@optional
- (void)label:(PTKLabel *)label didTapLinkWithURL:(NSURL *)url;

@end

@interface PTKLabel : UILabel

@property (nonatomic, assign) BOOL detectLinks;
@property (nonatomic, assign) CGFloat customLineSpacing;
@property (nonatomic, strong) NSDictionary *linkAttributes;
@property (nonatomic, weak) id<PTKLabelDelegate> delegate;
@property (nonatomic, strong) UIColor *internalTextColor;

- (void)setText:(NSString *)text withAdditionalLinks:(NSDictionary *)links;
- (NSURL *)linkAtPoint:(CGPoint)point;

@end
