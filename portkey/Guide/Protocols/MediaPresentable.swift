//
//  MediaCellPresentable.swift
//  portkey
//
//  Created by Samuel Beek on 15/01/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

protocol MediaCellPresentable {
    var imageUrl : URL {get}
    var title : String {get}
    var amountString : String {get}
}

extension MediaCellPresentable where Self : VideoObject {
    var amountString : String {
        guard let duration = self.duration , duration > 0 else {
            return ""
        }
        return PTKDatetimeUtility.formattedTimeInterval(duration)
    }
    
}

protocol MessagePresentable {
    func getMessage(_ roomId: String) -> PTKMessage?
}

protocol PlaylistPresentable : MediaCellPresentable {
    var id:String {get}
}

protocol fromJSON {
    init?(json: JSON)
}

protocol VideoObject {
    var duration : TimeInterval? {get}
}

