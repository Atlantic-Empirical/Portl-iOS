//
//  PTKVimeoResultViewController.swift
//  portkey
//
//  Created by Samuel Beek on 11/01/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import UIKit


@objc class PTKVimeoResultsViewController : PTKVideoResultsViewController {
    
    init(roomId: String, brandColor: UIColor) {
        super.init(roomId: roomId, brandColor: brandColor, viewModel: PTKGenericMediaDataSource<PTKVimeoObject>(endpoint: PTKVimeoAPI.Endpoint.Search.rawValue), channel: kPTKGuideChannelVimeo)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

        
}

