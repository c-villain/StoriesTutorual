//
//  UISlide.swift
//  StoriesTutorial
//
//  Created by Alexander Kraev on 23.12.2020.
//

import UIKit
import BlueprintUI
import BlueprintUICommonControls

// MARK: ui slide

struct UISlide : ProxyElement {
    
    var showLabels: Bool
    var slide: Slide
    var isLastSlide: Bool = false
    
    var onNextTap : ( () -> () )?
    var onPreviousTap : ( () -> () )?
    var onCloseTap : ( () -> () )?
    var onLastSlideNextTap : ( () -> () )?
    var onButtonTap : ( (URL?) -> () )?

    private var isFirstDisplayed = false
    
    // MARK: init for configure tapping on screen area for transition between stories
    public init(slide: Slide, showLabels: Bool, configure: (inout UISlide) -> Void = { _ in }) {
        self.showLabels = showLabels
        self.slide = slide
        configure(&self)
    }
    
    var elementRepresentation: Element {
        EnvironmentReader { (environment) -> Element in
            /**
                set horizontal insets on each ui element separately because of story's image,
                which hasn't insets at all
             */
            var overlay: Element
            if showLabels {
                overlay = Overlay(elements: [banner, tappableAreas, upperItems, button])
            } else {
                overlay = Overlay(elements: [banner, tappableAreas])
            }
            return overlay
                .inset(top: 0
                       ,bottom: 0
                       ,left: 0
                       ,right: 0)
                .box(background: slide.background, clipsContent: true )
        }
    }
    
    var banner: Element {
        EnvironmentReader { (environment) -> Element in
            /// whole screen size image:
            if (slide.image != nil) {
                let image = Image(image: slide.image,
                                  contentMode: .aspectFill)
                    .constrainedTo(width: .atMost(UIScreen.main.bounds.width), height: .atMost( (UIScreen.main.bounds.height)))
                return Overlay(elements: [image]).inset(top: 0
                      ,bottom: 0, left: 0, right: 0)
            }
            else { return Empty() }
        }
    }
    
    // MARK: title, desc, image
    var upperItems: Element {
        EnvironmentReader { (environment) -> Element in
            Column { col in
                
                col.horizontalAlignment = .fill
                col.verticalUnderflow = .justifyToStart
                
                /// title
                let header = Label(text: slide.title) { label in
                    label.color = slide.titleColor
                    label.font = .systemFont(ofSize: 18.0, weight: .semibold)
                }.inset(top: environment.safeAreaInsets.top + 60, bottom: 0, left: 24, right: 24)
                
                col.add(child: header)
                
                col.add(child: Spacer(8.0))
                
                /// desc
                let desc = Label(text: slide.description){ label in
                    label.color = slide.descColor
                    label.font = .systemFont(ofSize: 15.0, weight: .semibold)
                }.inset(top: 0, bottom: 0, left: 24, right: 24)
                
                col.add(child: desc)
            }
        }
    }
    
    // MARK: bottom button
    var button: Element {
        EnvironmentReader { (environment) -> Element in
        Column { col in
            
            col.horizontalAlignment = .fill
            col.verticalUnderflow = .justifyToEnd
            
            /// add button to stack
            
            if let buttonText = slide.buttonText, !buttonText.isEmpty {
                
                let button = Label(text: buttonText) { label in
                    label.alignment = .center
                    label.font = .systemFont(ofSize: 15.0, weight: .semibold)
                }
                
                .box(
                    background: slide.buttonColor,
                    corners: .rounded(radius: 14.0),
                    shadow: .simple(
                        radius: 6.0,
                        opacity: 0.2,
                        offset: .init(width: 0, height: 3.0),
                        color: .black
                    )
                )
                .constrainedTo(width: .absolute(288), height: .absolute(48))
                .inset(top: 0, bottom: environment.safeAreaInsets.bottom + 16, left: 24, right: 24)
                .tappable {
                    onButtonTap?(slide.buttonLink)
                }
                
                col.add(child: button)
            }
        }
        }
    }
    
    // MARK: areas for transition between stories
    
    var tappableAreas: Element {
        GeometryReader { (geometry) -> Element in
            
            let screenWidth: CGFloat = geometry.constraint.width.maximum / 3
            let screenHeight: CGFloat = geometry.constraint.height.maximum
            
            let previousBox = Box(backgroundColor: .clear)
                .constrainedTo(width: .absolute(screenWidth), height: .absolute(screenHeight))
                .tappable { onPreviousTap?() }
            
            let nextBox = Box(backgroundColor: .clear)
                .constrainedTo(width: .absolute(screenWidth * 2), height: .absolute(screenHeight))
                .tappable {
                    /**
                     tap on screen: if story is last, then close stories,
                                if no, then go to next story:
                     */
                    if (isLastSlide) {
                        onLastSlideNextTap?()
                    }
                    else { onNextTap?() }
                }
            
            return Row { col in
                col.add(child: previousBox )
                col.add(child: nextBox )
            }.constrainedTo(width: .absolute(screenWidth * 2), height: .absolute(screenHeight))
        }
    }
}


