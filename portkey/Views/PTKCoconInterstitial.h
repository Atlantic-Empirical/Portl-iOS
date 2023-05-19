//
//  PTKCoconInterstitial.h
//  portkey
//
//  Created by Nick Galasso on 3/10/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PTKDirection){
    PTKDirectionForwards,
    PTKDirectionBackwards
};

@interface PTKCoconInterstitial : UIView

-(instancetype)initWithFrame:(CGRect)frame direction:(PTKDirection)dir;

@end

