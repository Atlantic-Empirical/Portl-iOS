//
//  Devices.swift
//  portkey
//
//  Created by Samuel Beek on 1/26/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import Foundation

// some #define-constants don't work in Swift, thats why this struct has been created.
struct Devices {
    
    static let iPhone4 = UIScreen.main.bounds.size.height == 480.0
    static let iPhone5 = UIScreen.main.bounds.size.height == 568.0
    static let iPhone6 = UIScreen.main.bounds.size.height == 667.0
    static let iPhone6plus = UIScreen.main.bounds.size.height == 736.0
    static let small = !iPhone6 && !iPhone6plus
    static let big = !iPhone4 && !iPhone5
    
}
