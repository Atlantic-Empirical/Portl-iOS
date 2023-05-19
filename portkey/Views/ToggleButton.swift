//
//  ToggleButton.swift
//  portkey
//
//  Created by Samuel Beek on 06/04/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import UIKit

class ToggleButton : UIButton {
    
    override func setImage(_ image: UIImage?, for state: UIControlState) {
        if state == UIControlState() {
            super.setImage(image, for: state)
            super.setImage(image!.alpha(0.25), for: .selected)
        } else {
            super.setImage(image, for: state)
        }
    }
    
}
