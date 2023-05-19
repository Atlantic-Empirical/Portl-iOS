//
//  PTKBingImageSearchResult.swift
//  portkey
//
//  Created by Kay Vink on 03/11/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

import Foundation

struct PTKBingWebSearchResult: CustomStringConvertible {
    
    var displayUrl: String?
    var originalUrl: String?
    var pageTitle: String?
    var pageDescription: String?
    var pageType: String?
    
    
    init(json: JSON){
        
        self.displayUrl = json["DisplayUrl"].string
        self.originalUrl = json["Url"].string
        self.pageTitle = json["Title"].string
        self.pageDescription = json["Description"].string
        self.pageType = json["metadata"]["type"].string
    }
    
    var description: String { return "\(displayUrl), \(originalUrl), \(pageTitle), \(pageDescription), \(pageType)" }
    
}