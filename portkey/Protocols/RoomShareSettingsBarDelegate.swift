//
//  RoomShareSettingsBarDelegate.swift
//  portkey
//
//  Created by Samuel Beek on 06/04/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import Foundation

protocol RoomShareShowLinkBarDelegate : class, CanPresentViewController {
    
    func roomShareSettingsBar(_ roomShareSettingsBar: RoomShareShowLinkBar, shouldShowLink show: Bool) -> Void

}

