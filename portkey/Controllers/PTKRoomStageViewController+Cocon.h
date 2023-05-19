//
//  PTKRoomStageViewController+Cocon.h
//  portkey
//
//  Created by Nick Galasso on 2/24/17.
//  Copyright © 2017 Airtime Media. All rights reserved.
//

#import "PTKRoomStageViewController.h"

@interface PTKRoomStageViewController (Cocon)

-(void)onMediaPrepare:(NSNotification*)note;
-(void)onMediaSync:(NSNotification*)note;
-(void)emitMediaReady;
-(void)beginPlayback;
-(NSArray<NSString*>*)supportedTypes;
-(void)processMediaPrepare;

@end

@interface AVPlayerItem (Cocon)

-(BOOL)isReadyToPlayAtPosition:(NSNumber*)pos;

@end


