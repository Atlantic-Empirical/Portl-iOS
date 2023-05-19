//
//  PTKVideoPlaylistCell.swift
//  portkey
//
//  Created by Samuel Beek on 1/20/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import UIKit

@objc class PTKVideoPlaylistCell : PTKVideoCell {
    
    // unfortanetely it was not alloewd to remove the WithPlaylsit
    func configureWithPlaylist(_ playlist: PlaylistPresentable) {
        timeLabel.text = playlist.amountString
        super.configure(playlist)
    }
    
}
