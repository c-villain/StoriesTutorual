//
//  AppDelegate.swift
//  StoriesTutorial
//
//  Created by Alexander Kraev on 21.12.2020.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let router: Router = .init()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let root: RootViewController = .init(router: router)
        window?.rootViewController = UINavigationController(rootViewController: root)
        
        window?.makeKeyAndVisible()

        return true
    }
}

