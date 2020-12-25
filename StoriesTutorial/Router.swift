//
//  Router.swift
//  StoriesTutorial
//
//  Created by Alexander Kraev on 24.12.2020.
//

import Foundation
import UIKit
import SafariServices

final class Router {
    
    // UIWindows
    var window: UIWindow?
    var stories: UIWindow?
    
    init() {
        window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func showStories(root: UIViewController?, showLabels: Bool){
        let storiesVC: StoriesPlayerViewController = .init(showLabels: showLabels)
        storiesVC.modalPresentationStyle = .fullScreen
        stories = UIWindow()
        stories?.backgroundColor = .clear
        stories?.rootViewController = RootContainerViewController()
        stories?.makeKeyAndVisible()
        stories?.rootViewController?.present(storiesVC, animated: true)
    }
    
    func closeStories() {
        stories?.rootViewController?.dismiss(animated: true, completion: { [weak self] in
            self?.stories?.isHidden = true
            if #available(iOS 13, *) {
                self?.stories?.windowScene = nil
            }
        })
    }
    
}
