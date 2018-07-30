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
        case .events(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "eventsList") as! UINavigationController
            var tvc = nc.viewControllers.first as! EventsListTableViewController
            tvc.bindViewModel(to: viewModel)
            return nc
        case .displayEvents(let viewModel):
            let nc = storyboard.instantiateViewController(withIdentifier: "displayEvents") as! UINavigationController
            var vc = nc.viewControllers.first as! DisplayEventViewController
            vc.bindViewModel(to: viewModel)
            return nc
        }
    }
}
