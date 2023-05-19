//
//  PTKGuideFonts.swift
//  portkey
//
//  Created by Samuel Beek on 2/3/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import UIKit

struct PTKGuideFont {

    // cells
    static let titleFont = UIFont.systemFont(ofSize: 14.0)
    static let subtitleFont = UIFont.systemFont(ofSize: 12.0)
    
    
    static var headerTitleFont : UIFont {
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        } else {
            return UIFont.systemFont(ofSize: 14)
        }
    }
    static let headerButtonFont = UIFont.systemFont(ofSize: 14)

}
