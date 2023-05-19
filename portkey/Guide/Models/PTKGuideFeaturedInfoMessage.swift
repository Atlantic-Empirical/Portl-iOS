//
//  PTKGuideFeaturedInfoMessage.swift
//  portkey
//
//  Created by Kay Vink on 05/11/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

import Foundation

struct PTKGuideFeaturedInfoMessage {
    let message: String
    let backgroundColor: UIColor
    var image: UIImage?
    var openAction: (()->())?
    
    init(message: String, backgroundColor: UIColor){
        self.message = message
        self.backgroundColor = backgroundColor
    }
}