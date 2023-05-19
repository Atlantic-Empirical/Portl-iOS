//
//  DataSourceAble.swift
//  portkey
//
//  Created by Samuel Beek on 29/04/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import Foundation

protocol DataSourceAble {
    associatedtype DataType : fromJSON, MediaCellPresentable
}

protocol CanParse : DataSourceAble {
    func parseResponse(_ response: PTKAPIResponse) -> [MediaCellPresentable]
}
