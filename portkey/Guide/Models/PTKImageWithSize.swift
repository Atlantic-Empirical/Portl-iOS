//
//  PTKImageWithSize.swift
//  portkey
//
//  Created by Kay Vink on 23/10/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

import Foundation

@objc open class PTKImageWithSize: NSObject {
    
    let width: Int
    let height: Int
    let imageUrl: String
    
    public init(width: Int, height: Int, imageUrl: String) {
        self.width = width
        self.height = height
        self.imageUrl = imageUrl
    }
    
}
