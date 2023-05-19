//
//  Functional.swift
//  signal-soundcloud
//
//  Created by Kay Vink on 16/09/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

import Foundation

func flatten<A>(_ array: [A?]) -> [A] {
    var list: [A] = []
    for item in array {
        if let i = item {
            list.append(i)
        }
    }
    return list
}
