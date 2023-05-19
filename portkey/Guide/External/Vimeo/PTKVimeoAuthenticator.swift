//
//  PTKVimeoAuthenticator.swift
//  portkey
//
//  Created by Samuel Beek on 05/01/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import Foundation

struct PTKVimeoAuthenticator {
    
    var session: PTKMediaPickerSession?
    
    init() {
        if let sessionData = PTKKeychain.sharedInstance().vimeoSessionData {
            session = NSKeyedUnarchiver.unarchiveObject(with: sessionData) as? PTKMediaPickerSession
        }
    }
}




