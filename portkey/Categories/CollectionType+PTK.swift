//
//  CollectionType+PTK.swift
//  portkey
//
//  Created by Kay Vink on 27/10/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

import Foundation

extension Collection {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Iterator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollection where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        let countInt = count.toIntMax()
        
        for i in 0..<(countInt - 1) {
            let j = Int(arc4random_uniform(UInt32(countInt - i))) + i
            guard i != j else { continue }
            swap(&self[Int(i)], &self[Int(j)])
        }
    }
}
