//
//  PTKUserExtensions.swift
//  portkey
//
//  Created by Samuel Beek on 23/05/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import Foundation

extension PTKUser {
    var isFriend : Bool {
        return PTKWeakSharingManager.friendsDataSource().isMutualFriend(withUserId: self.oid())
    }
}
