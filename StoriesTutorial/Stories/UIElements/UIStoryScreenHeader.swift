//
//  UIStoryScreenHeader.swift
//  StoriesTutorial
//
//  Created by Alexander Kraev on 23.12.2020.
//

import UIKit
import BlueprintUI
import BlueprintUICommonControls

// MARK: - row of stories timers with close button

struct UIStoryScreenHeader: ProxyElement {
    
    var spacingBetweenLoaders: CGFloat = 8
    
    var viewModel: ViewModel
    var onCloseTap : ( () -> () )?
    
    public init(viewModel: ViewModel, configure: (inout UIStoryScreenHeader) -> Void = { _ in }) {
        self.viewModel = viewModel
        configure(&self)
    }

    var elementRepresentation: Element {
        Overlay(elements: [loaderRow, closeButton])
    }

    var loaderRow: Element {
        EnvironmentReader { (environment) -> Element in
            GeometryReader { (geometry) -> Element in
                
                guard self.viewModel.slides.count > 0 else { return Empty() }
                let screenWidth = geometry.constraint.width
                
                let size: CGSize = .init(width: screenWidth.maximum / CGFloat(self.viewModel.slides.count) - spacingBetweenLoaders, height: 4)
                
                return Row{ col in
                    col.horizontalUnderflow = .spaceEvenly
                    
                    for i in 1...self.viewModel.slides.count {
                        
                        col.add(child: Loader(progress : min( max( CGFloat(i) - (CGFloat(self.viewModel.progress) ), 0.0) , 1.0), size: size))
                    }
                }.inset(top: environment.safeAreaInsets.top + 8, bottom: 0, left: 8, right: 8)
            }
        }
    }
    
    var closeButton: Element {
        EnvironmentReader { (environment) -> Element in //for safe area insets
            GeometryReader { (geometry) -> Element in
                
                let leftInset: CGFloat = geometry.constraint.width.maximum
                                - 24 //button size
                                - 12 // right inset
                return Row { row in
                    
                    let closeButton = Image(image: UIImage(named: "close"),
                                            contentMode: .aspectFill)
                        .constrainedTo(width: .absolute(18), height: .absolute(18)).tappable {
                            onCloseTap?()
                        }
                    row.add(child: closeButton)
                }.inset(top: environment.safeAreaInsets.top + 8 + 4 + 16, bottom: 0, left: leftInset, right: 8)
            }
        }
    }
}

// MARK: - one story timer element

fileprivate struct Loader: ProxyElement {
    
    /// dynamic width of loading 
    var progress: CGFloat
    
    /// size of single loader
    var size: CGSize

    var elementRepresentation: Element {
            
        let grey = ConstrainedSize (width: .absolute(size.width) ,
                                    height: .absolute(size.height),
                                    wrapping: Box(backgroundColor: UIColor.white.withAlphaComponent(0.3),
                                                  cornerStyle: .rounded(radius: 2) )
        )
        
        let blue = ConstrainedSize(
            width: .absolute(size.width),
            height: .absolute(size.height),
            wrapping: Box(backgroundColor: UIColor.white,
                          cornerStyle: .rounded(radius: 2) )
                        .inset(left: 0, right: size.width * progress)
        )
        
        return Overlay(elements: [grey, blue])
    }

}



