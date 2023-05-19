//
//  PTKTedResultsViewController.swift
//  portkey
//
//  Created by Samuel Beek on 1/20/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

@objc class PTKTedResultsViewController : PTKVideoResultsViewController {
    
    init(roomId: String, brandColor: UIColor) {
        super.init(roomId: roomId, brandColor: brandColor, viewModel: PTKYoutubeMediaDataSource(endpoint: "/youtube/channels/\(PTKYouTubeAPI.TEDUserId)/videos"), channel: kPTKGuideChannelTED)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
