//
//  PTKAlertViewController.swift .swift
//  portkey
//
//  Created by Samuel Beek on 11/07/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import UIKit

/**
 PTKAlertViewController is very similar to UIAlertActionViewController. 
 
 The main difference is the layout and the fact that an emoji/icon is shown at the top of the Alert.
 Instead of UIAlertAction, we use PTKAlertAction for creating actions (buttons) on this view.
 
 By assigning the actions like this, they become buttons on the AlertView:
 __Objective-C:__
 
 `alert.actions = @[skip, claim];`
 
 __Swift:__
 
 `alert.actions = [skip, claim]`
 */
@objc class PTKAlertViewController : UIViewController {
    
    internal var alertView : PTKAlertView!
    
    /// When setting these, they will become buttons on the Alert View
    var actions = [PTKAlertAction]() {
        didSet {
            var buttons = [UIButton]()
            for action in actions {
                buttons.append(action.alertButtonForAction())
            }
            alertView.addButtons(buttons)
        }
    }
    
    fileprivate init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    internal convenience init(title: String, description: String, emoji: String) {
        let attributedString = PTKAlertView.attributedStringForDescription(description)
        self.init(title: title, attributedDescription: attributedString, icon: nil, emoji: emoji, showBlur: true)
    }

    internal convenience init(title: String, attributedDescription: NSAttributedString, emoji: String) {
        self.init(title: title, attributedDescription: attributedDescription, icon: nil, emoji: emoji, showBlur: true)
    }

    internal convenience init(title: String, description: String) {
        let attributedString = PTKAlertView.attributedStringForDescription(description)
        self.init(title: title, attributedDescription: attributedString, icon: nil, emoji: nil, showBlur: true)
    }

    internal convenience init(title: String, description: String, icon: UIImage) {
        let attributedString = PTKAlertView.attributedStringForDescription(description)
        self.init(title: title, attributedDescription: attributedString, icon: icon, emoji: nil, showBlur: true)
    }
    
    internal convenience init(title: String, contentView: UIView, contentSize:CGSize) {
        self.init(title: title, attributedDescription: nil, icon: nil, emoji: nil, showBlur: false, contentView:contentView, contentSize:contentSize)
    }
    
    internal convenience init(title: String, attributedDescription: NSAttributedString, icon: UIImage) {
        self.init(title: title, attributedDescription: attributedDescription, icon: icon, emoji:nil, showBlur: true)
    }
    
    internal convenience init(title: String, attributedDescription: NSAttributedString) {
        self.init(title: title, attributedDescription: attributedDescription, icon: nil, emoji: nil, showBlur: true)
    }
    
    internal convenience init(title: String, attributedDescription: NSAttributedString, icon: UIImage? = nil, emoji: String? = nil) {
        self.init(title: title, attributedDescription: attributedDescription, icon: nil, emoji: nil, showBlur: true)
    }

    internal convenience init(title: String, description: String, icon: UIImage? = nil, showBlur: Bool = true) {
        let attributedString = PTKAlertView.attributedStringForDescription(description)
        self.init(title: title, attributedDescription: attributedString, icon: icon, emoji: nil, showBlur: showBlur)
    }

    internal init(title: String, attributedDescription: NSAttributedString?, icon: UIImage? = nil, emoji: String? = nil, showBlur: Bool = true, contentView:UIView? = nil, contentSize:CGSize = CGSize.zero) {
        super.init(nibName: nil, bundle: nil)
       
        var desc:NSAttributedString! = attributedDescription
        if (desc == nil){
            desc = NSAttributedString()
        }
        
        alertView = PTKAlertView(title: title, description: desc, icon: icon, emoji: emoji, showBlur: showBlur, contentView:contentView, contentSize:contentSize)
            
        view.addSubview(alertView)
        
        alertView.frame = view.bounds
        alertView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        modalPresentationStyle = .overFullScreen;
        modalTransitionStyle = .crossDissolve
    }
    
    internal func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
}
