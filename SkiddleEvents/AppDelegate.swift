//
//  AppDelegate.swift
//  SkiddleEvents
//
//  Created by Fuad Adetoro on 29/07/2018.
//  Copyright © 2018 PREE. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let sceneCoordinator = SceneCoordinator(window: window!)
        
        let eventsListViewModel = EventsListViewModel(sceneCoordinator: sceneCoordinator)
        let firstScene = Scene.events(eventsListViewModel)
        sceneCoordinator.transition(to: firstScene, type: .root)
        
        return true
    }
}

