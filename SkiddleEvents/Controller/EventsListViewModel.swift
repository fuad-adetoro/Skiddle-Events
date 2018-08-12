//
//  EventsListViewModel.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 30/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct EventsListViewModel: ViewModel {
    var sceneCoordinator: SceneCoordinatorType
    var viewModelType: ViewModelType
    
    let searchText: Variable<String> = Variable("")
    
    init(sceneCoordinator: SceneCoordinatorType) {
        self.sceneCoordinator = sceneCoordinator
        self.viewModelType = .eventsListViewModel
    }
    
    lazy var events: Observable<[Event]> = {
        return self.searchText.asObservable().throttle(0.3, scheduler: MainScheduler.instance).distinctUntilChanged().flatMapLatest(EventsListViewModel.retrieveEvents).share()
    }()
    
    static func retrieveEvents(_ urlString: String) -> Observable<[Event]> {
        return SkiddleAPI.shared.parseEvents(urlString)
    }
}
