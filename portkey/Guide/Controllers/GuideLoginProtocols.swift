//
//  GuideLoginDelegates.swift
//  portkey
//
//  Created by Samuel Beek on 1/19/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

import UIKit

/**
 *  GuideLoginDelegate is used to 
 *  Communicate with the LoginController.
 */
protocol GuideLoginDelegate {
    func didLogin(_ controller: UIViewController)
    func didFail(_ controller: UIViewController)
}

/**
 *  Protocol to ensure all 
 *  ViewControllers that have login functionality
 *  behave in the same manner.
 */
@objc protocol GuideLoginProtocol {
    
    var isSigningIn : Bool {get set}
    func login()
    @objc optional func didFetchLink(_ error: NSError?, jsonDict: NSDictionary?)
    @objc optional func handleWebViewRequest(_ request: URLRequest) -> Bool
}
