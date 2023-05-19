//
//  CanPresentViewController.swift
//  portkey
//
//  Created by Samuel Beek on 06/04/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import Foundation

protocol CanPresentViewController {
    
    func presentViewController(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func dismissViewControllerAnimated(_ flag: Bool, completion: (() -> Void)?)

}
