//
//  PTKGuideNavigationController.swift
//  portkey
//
//  Created by Samuel Beek on 2/12/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import UIKit

class PTKGuideNavigationController : PTKNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = .black
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
