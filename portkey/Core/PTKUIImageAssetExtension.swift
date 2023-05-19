//
//  UIImageExtension.swift
//  jackiebrown
//
//  Created by Kay Vink on 23/09/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    
    enum Asset: String {
        
        case SoundCloud = "SoundCloud"
        case SoundCloudHorizontal = "SoundCloudHorizontal"
        case Spotify    = "Spotify"
        case Giphy      = "Giphy"
        case GiphyHorizontal = "GiphyHorizontal"
        case YouTube    = "YouTube"
        case iHeart     = "iHeart"
        case iHeartHorizontal = "iheartHorizontal"
        case Vice       = "Vice"
        case Vevo       = "Vevo"
        case Mtv        = "Mtv"
        case Vimeo      = "vimeo"
        case Google     = "Google"
    }
    
    convenience init(asset: Asset){
                
        self.init(named: asset.rawValue)!
    }
    
}