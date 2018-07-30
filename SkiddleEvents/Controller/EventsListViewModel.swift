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
import RxAlamofire
import SwiftyJSON

struct EventsListViewModel {
    let sceneCoordinator: SceneCoordinatorType
    
    let searchText: Variable<String> = Variable("")
    
    init(sceneCoordinator: SceneCoordinatorType) {
        self.sceneCoordinator = sceneCoordinator
    }
    
    lazy var data: Driver<[Event]> = {
        return self.searchText.asObservable().throttle(0.4, scheduler: MainScheduler.instance).distinctUntilChanged().flatMapLatest(EventsListViewModel.parseEvent).asDriver(onErrorJustReturn: [])
    }()
    
    static func parseEvent(_ urlString: String) -> Observable<[Event]> {
        guard !urlString.isEmpty, let url = URL(string: urlString) else {
            return Observable.just([])
        }
        
        return RxAlamofire.request(.get, url).flatMap { request in
            return request.validate(statusCode: 200 ..< 300).rx.json()
            }.map { value in
                JSON(value)
            }.map { json in
                json["results"]
            }.map { resultJSON -> [Event] in
                SkiddleAPI.shared.events(from: resultJSON)
            }
    }
}
