//
//  DisplayEventViewModel.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 30/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct DisplayEventViewModel {
    let sceneCoordinator: SceneCoordinatorType
    let event: Event
    
    init(sceneCoordinator: SceneCoordinatorType, event: Event) {
        self.sceneCoordinator = sceneCoordinator
        self.event = event
    }
}
