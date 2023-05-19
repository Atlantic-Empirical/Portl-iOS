//
//  StringHelper.swift
//  signal-soundcloud
//
//  Created by Samuel Beek on 17/09/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

import UIKit

extension String {
    
    func limitString(_ max: Int) -> String{
        
        if self.characters.count < max {
            return self
        }
        
        if characters.count > 1 {
            return self.substring(to: self.characters.index(self.startIndex, offsetBy: max))
        }
        
        return ""
    }
 
    
    /// Use: String.localize("Join room now")
    static func localize(_ key: String) -> String {
        return NSLocalizedString(key, comment: "") 
    }

}
