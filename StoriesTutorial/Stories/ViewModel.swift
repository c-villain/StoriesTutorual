//
//  ViewModel.swift
//  StoriesTutorial
//
//  Created by Alexander Kraev on 23.12.2020.
//

import Foundation
import UIKit

import OpenCombine

final class ViewModel {
    
    @OpenCombine.Published var isLoading = false
    
    // MARK: for story timer slide
    private var timer: Timer?
    @OpenCombine.Published var progress: Double = 0
    @OpenCombine.Published var storiesEnd: Bool = false
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    var showLabels: Bool = true
    
    var slides: [Slide] {
        let slide1 = Slide (id: 1,
                            title: "Yiran Ding",
                            description: "",
                            imageName: "1" )
        
        let slide2 = Slide (id: 2,
                            title: "Chris Yang",
                            description: "On August, I spent about two weeks in Iceland and Greenland. This glacier was the first astonishment as we arrived in Iceland. The first time in my life sitting so close to the glacier and touch the cold water. Not just cold but extremely freezing. Still, an unbelievably beautiful scenery with no doubt.",
                            imageName: "2")
        
        let slide3 = Slide (id: 3,
                            title: "Kyle Johnson",
                            description: "Iceland ",
                            imageName: "3")
        
        let slide4 = Slide (id: 4,
                            title: "Puneeth Shetty",
                            description: "A hiker with his dog. On top of Untersberg in Salzburg, Austria.",
                            buttonText: "Show photos with same theme",
                            buttonColor: .systemBlue,
                            buttonLink: URL(string: "https://unsplash.com/s/photos/arctic"),
                            imageName: "4")
        
        let slide5 = Slide(id: 5,
                           title: "Madeline Pere",
                           description: "White Sands National Monument in New Mexico, USA has been on my wishlist for years. Seeing photographers take some of the most stunning images I have ever seen, I knew when I had the chance I had to visit.",
                           imageName: "5")
        
        let slide6 = Slide(id: 6,
                           title: "Annie Spratt",
                           titleColor: .brown,
                           description: "Aerial (drone) view of Arctic Icebergs",
                           descColor: .brown,
                           imageName: "6")
        return [slide1, slide2, slide3, slide4, slide5, slide6]
        
    }
    
}

extension ViewModel {
    
    func startTimer(){
        self.storiesEnd = false
    
        stopTimer() //if timer not nil
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            var newProgress = self.progress + (0.1 / 5.0) //5 seconds length
            if Int(newProgress) >= self.slides.count {
                self.storiesEnd = true
                newProgress = 0
            }
            self.progress = newProgress
        }
        self.timer?.tolerance = 0.2
    }
    
    func advance(by number: Int) {
        let newProgress = Swift.max((Int(self.progress) + number) % slides.count, 0)
        self.progress = Double(newProgress)
    }
    
    func freezeTimer(){
        if self.timer != nil {
            timer!.invalidate()
        }
    }
    
    func resumeTimer(){
        if self.timer != nil {
            self.startTimer()
        }
    }
    
    func stopTimer(){
        if self.timer != nil {
            timer!.invalidate()
            self.timer = nil
        }
    }
}

extension ViewModel {
    func close() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        delegate.router.closeStories()
    }
}


