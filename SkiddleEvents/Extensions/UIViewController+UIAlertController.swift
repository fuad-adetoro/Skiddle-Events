//
//  UIViewController+UIAlertController.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 11/08/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import UIKit

typealias AlertCompletion = (UIAlertAction) -> Void

extension UIViewController {
    func displayAlertController(title: String?, message: String?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        return alertController
    }
    
    func displayAlertController(with alertTitle: String, using style: UIAlertActionStyle, handler: @escaping AlertCompletion, controllerTitle title: String?, controllerMessage message: String?) -> UIAlertController {
        let alertController = displayAlertController(title: title, message: message)
        
        let alertAction = UIAlertAction(title: alertTitle, style: style, handler: handler)
        alertController.addAction(alertAction)
        
        return alertController
    }
    
    func dismissCurrentAlertController(in viewController: UIViewController, completion: @escaping (()) -> Void) {
        if viewController.presentedViewController != nil {
            viewController.dismiss(animated: true, completion: completion)
        }
    }
    
    func dismissCurrentAlertController(in viewController: UIViewController) {
        if viewController.presentedViewController != nil {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}

