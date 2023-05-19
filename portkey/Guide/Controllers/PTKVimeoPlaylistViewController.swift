//
//  PTKVimeoPlaylistTableViewCotnroller.swift
//  portkey
//
//  Created by Samuel Beek on 2/3/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import Foundation

class PTKVimeoPlaylistViewController : PTKVideoTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let object : MessagePresentable = videos[safe: (indexPath as NSIndexPath).row] as? MessagePresentable else {
            return
        }
        
        let message = object.getMessage(roomId)
        if let preview = PTKMessagePreviewViewController(message: message) {
            preview.delegate = self
            present(preview, animated: true, completion: nil)
        }
    }
    
}
