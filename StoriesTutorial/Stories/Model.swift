//
//  Model.swift
//  StoriesTutorial
//
//  Created by Alexander Kraev on 23.12.2020.
//

import Foundation
import UIKit

//MARK: - Model of story for displaying

public struct Slide : Equatable, Hashable {
    
    var id: Double
    
    /// Story's image
    var image: UIImage?
    
    /// Story's title and its color
    var title: String
    var titleColor: UIColor
    
    /// Story's description and its color
    var description: String
    var descColor: UIColor
    
    /// Story's bottom button, its color and url
    var buttonText: String?
    var buttonColor: UIColor = .lightGray
    var buttonLink: URL?
    
    /// Story's background
    var background: UIColor
    
    init(id: Double,
         title: String,
         titleColor: UIColor = .black,
         description: String,
         descColor: UIColor = .darkGray,
         buttonText: String = "",
         buttonColor: UIColor = .lightGray,
         buttonLink: URL? = nil,
         imageName: String,
         background: UIColor = .clear) {
        
        self.id = id
        
        self.title = title 
        self.titleColor = titleColor
        
        self.description = description
        self.descColor = descColor
        
        self.buttonText = buttonText
        self.buttonColor = buttonColor
        self.buttonLink = buttonLink
        
        self.image = UIImage(named: imageName)
        
        self.background = background
    }
    
}
