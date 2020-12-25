//
//  UIStoryScreen.swift
//  StoriesTutorial
//
//  Created by Alexander Kraev on 23.12.2020.
//

import Foundation
import BlueprintUI
import BlueprintUICommonControls

// MARK: main view of stories (slider with header: loader with timer and close button)

struct UIStoryScreen : ProxyElement {
    
    var viewModel: ViewModel
    
    /// action go to next stories
    var onNextTap : ( () -> () )?
    
    /// action go to previous stories
    var onPreviousTap : ( () -> () )?
    
    /// action tap on close button
    var onCloseTap : ( (Int) -> () )?
    
    /// tap on close stories on the last slide
    var onLastSlideNextTap : ( () -> () )?
    
    /// tap on slide button
    var onButtonTap : ( (URL?) -> () )?
    
    // MARK: init for configure of tapping on screen area (for transition between slides)
    public init(viewModel: ViewModel, configure: (inout UIStoryScreen) -> Void = { _ in }) {
        self.viewModel = viewModel
        configure(&self)
    }
    
    var elementRepresentation: Element {
        
        let currentSlide: Int = .init(self.viewModel.progress)
        /// ui slide
        let slide = UISlide(slide: viewModel.slides [ currentSlide ], showLabels: viewModel.showLabels){
            $0.onNextTap = onNextTap
            $0.onPreviousTap = onPreviousTap
            $0.onCloseTap = {
                onCloseTap?(currentSlide)
            }
            $0.onLastSlideNextTap = onLastSlideNextTap
            $0.onButtonTap = onButtonTap
            $0.isLastSlide = (currentSlide == viewModel.slides.count - 1) ? true : false
        }.transition(onAppear: .fade, onDisappear: .none, onLayout: .none)
        
        /// loader with timer and close button 
        let loader = UIStoryScreenHeader(viewModel: self.viewModel) {
            $0.onCloseTap = {
                onCloseTap?(currentSlide)
            }
        }

        return Overlay (elements: [slide, loader])
    }
    
}
