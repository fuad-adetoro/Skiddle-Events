//
//  Scene+viewController.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 30/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import UIKit

extension Scene {
    func viewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch self {
        case .events(let eventsListViewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "eventsList") as! UINavigationController
            var vc = nc.viewControllers.first as! EventsListViewController
            vc.bindViewModel(to: eventsListViewModel)
            return nc
        case .displayEvents(let displayEventViewModel):
            var vc = storyboard.instantiateViewController(withIdentifier: "displayEvents") as! DisplayEventViewController
            vc.bindViewModel(to: displayEventViewModel)
            return vc
        }
    }
}
