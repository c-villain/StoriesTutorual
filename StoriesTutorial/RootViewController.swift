//
//  RootViewController.swift
//  StoriesTutorial
//
//  Created by Alexander Kraev on 24.12.2020.
//

import Foundation


import UIKit
import BlueprintUI
import BlueprintUICommonControls


final class RootViewController : UIViewController
{
    var router: Router?
    
    fileprivate var demos : [ButtonItem] {
        [
            ButtonItem(title: "Show arctic stories", onTap: { [weak self] in
                self?.router?.showStories(root: self, showLabels: true)
            }) ,
            
            ButtonItem(title: "Show arctic stories without labels", onTap: { [weak self] in
                self?.router?.showStories(root: self, showLabels: false)
            })
        ]
    }
    
    convenience init(router: Router) {
        self.init()
        self.router = router
    }
    
    override func loadView() {
        let blueprintView = BlueprintView(element: self.contents)

        self.view = blueprintView

        self.view.backgroundColor = .white
    }

    var contents : Element {
        Column { column in
            column.minimumVerticalSpacing = 20.0
            column.horizontalAlignment = .fill
            
            self.demos.forEach { demo in
                column.add(child: demo)
            }
        }
        .constrainedTo(width: .within(300...500))
        .aligned(vertically: .top, horizontally: .center)
        .inset(uniform: 24.0)
        .scrollable(.fittingHeight) { scrollView in
            scrollView.alwaysBounceVertical = true
        }
    }
}

fileprivate struct ButtonItem : ProxyElement
{
    var title : String
    var onTap : () -> ()

    var elementRepresentation: Element {
         Label(text: self.title) { label in
            label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        }
        .inset(uniform: 20.0)
        .box(
            background: .white,
            corners: .rounded(radius: 14.0),
            shadow: .simple(
                radius: 6.0,
                opacity: 0.2,
                offset: .init(width: 0, height: 3.0),
                color: .black
            )
        )
        .tappable {
            self.onTap()
        }
    }
}

