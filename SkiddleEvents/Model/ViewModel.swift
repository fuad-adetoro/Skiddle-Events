//
//  ViewModel.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 11/08/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import UIKit

enum ViewModelType {
    case eventsListViewModel
    case displayEventViewModel
}

protocol ViewModel {
    var sceneCoordinator: SceneCoordinatorType { get set }
    var viewModelType: ViewModelType { get set }
}
