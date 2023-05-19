//
//  UIViewControllerExtensions.swift
//  portkey
//
//  Created by Samuel Beek on 05/01/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     Shows AlertView inside a UIViewController
     
     - parameter title:   Title of the alert
     - parameter message: What it says
     - parameter button:  What the button says, defaults to OK
     */
    func showAlert(_ title: String, message: String, button: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}

