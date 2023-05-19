//
//  PTKGuideChannelHeaderFooterView.swift
//  portkey
//
//  Created by Kay Vink on 11/11/15.
//  Copyright © 2015 Airtime Media. All rights reserved.
//

import UIKit

class PTKGuideChannelHeaderFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        textLabel?.textColor = PTKColor.grayColor()
        textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        backgroundView = UIView(frame: self.bounds)
        backgroundView?.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
