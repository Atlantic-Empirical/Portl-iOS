//
//  PTKVimeoPopularViewController.swift
//  portkey
//
//  Created by Samuel Beek on 23/11/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

import UIKit

@objc class PTKVimeoPopularViewController: PTKVideoCollectionViewController {
 
    
    init(roomId: String) {
        super.init(roomId: roomId, brandColor: PTKColor.vimeoBrandColor(), viewModel: PTKGenericMediaDataSource<PTKVimeoObject>(endpoint: PTKVimeoAPI.Endpoint.Popular.rawValue))
        self.title = "Popular"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
