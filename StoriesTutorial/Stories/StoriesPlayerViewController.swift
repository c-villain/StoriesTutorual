//
//  PlayerView.swift
//  StoriesTutorial
//
//  Created by Alexander Kraev on 23.12.2020.
//

import UIKit
import BlueprintUI
import BlueprintUICommonControls
import OpenCombine
import SafariServices

final class RootContainerViewController: UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = .clear
    }
}

final class StoriesPlayerViewController: UIViewController {

    var safariViewController: SFSafariViewController?
    
    var viewModel: ViewModel
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let blueprintView: BlueprintView = .init()
    
    init(showLabels: Bool = true) {
        self.viewModel = .init()
        self.viewModel.showLabels = showLabels
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = blueprintView
    }
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        update()
        setupBinding()
        /// Add "long" press gesture recognizer for "freeze" onboarding
        let tap: UILongPressGestureRecognizer = .init(target: self, action: #selector(panGestureRecognizerHandler))
        tap.minimumPressDuration = 0.2
        tap.delaysTouchesBegan = true
        blueprintView.addGestureRecognizer(tap)
        
        /// Add pan gesture for sliding onboarding:
        let swipeDown: UIPanGestureRecognizer = .init(target: self, action: #selector(panGestureRecognizerHandler))
        blueprintView.addGestureRecognizer(swipeDown)
    }
    
    /// var to store initial touch position for pan gesture:
    var initialTouchPoint: CGPoint = .init(x: 0, y: 0)
    
    @objc func panGestureRecognizerHandler(gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: self.view?.window)
        if gesture.state == .began {
            initialTouchPoint = touchPoint
            self.viewModel.freezeTimer()
        } else if gesture.state == .changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                blueprintView.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: blueprintView.frame.size.width, height: blueprintView.frame.size.height)
            }
        } else if gesture.state == .ended || gesture.state == .cancelled {
            if touchPoint.y - initialTouchPoint.y > 150 {
                self.viewModel.stopTimer()
                self.viewModel.close()
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.blueprintView.frame = CGRect(x: 0, y: 0, width: self.blueprintView.frame.size.width, height: self.blueprintView.frame.size.height)
                    self.viewModel.resumeTimer()
                })
            }
        }
    }
    
    private func setupBinding() {
        self.viewModel
            .$isLoading
            .sink { [weak self] isLoading in
                if (!isLoading) {
                    self?.viewModel.startTimer() //start timer for stories
                    self?.update()
                }
            }
            .store(in: &cancellables)
        
        self.viewModel.$progress.sink { [weak self] _ in
            self?.update()
        }.store(in: &cancellables)
        
        self.viewModel
            .$storiesEnd
            .sink { [weak self] isEnd in
                if (isEnd) {
                    self?.viewModel.stopTimer()
                    self?.viewModel.close()
                }
                else { }
            }
            .store(in: &cancellables)
    }
    
    private func update() {
        blueprintView.element = UIStoryScreen(viewModel: self.viewModel){
            
            $0.onNextTap = { [weak self] in
                self?.viewModel.stopTimer()
                self?.viewModel.advance(by: 1)
                self?.viewModel.startTimer()
            }
            $0.onPreviousTap = { [weak self] in
                self?.viewModel.stopTimer()
                self?.viewModel.advance(by: -1)
                self?.viewModel.startTimer()
            }
            $0.onCloseTap = { [weak self] slideNum in
                self?.viewModel.stopTimer()
                self?.viewModel.close()
            }
            $0.onLastSlideNextTap = { [weak self] in
                self?.viewModel.stopTimer()
                self?.viewModel.close()
            }
            $0.onButtonTap = { [weak self] url in
                self?.viewModel.stopTimer()
                if url != nil {
                    self?.routeToURL(url)
                } else {
                    self?.viewModel.close()
                }
            }
        }
    }
    
}

extension StoriesPlayerViewController {

    func routeToURL(_ url: URL?) {
        guard let url = url else { return }
        
        safariViewController = SFSafariViewController(url: url)
        safariViewController?.delegate = self
        guard let safariVC = safariViewController else { return }
        self.present(safariVC, animated: true, completion: nil)
    }
}

extension StoriesPlayerViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.viewModel.startTimer()
    }
}
