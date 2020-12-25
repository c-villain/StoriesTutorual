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
        /// Add "long" press gesture recognizer for "freeze" stories 👇🏻
        let tap: UILongPressGestureRecognizer = .init(target: self, action: #selector(tapHandler))
        tap.minimumPressDuration = 0.2
        tap.delaysTouchesBegan = true
        blueprintView.addGestureRecognizer(tap)
    }
    
    private func setupBinding() {
        self.viewModel
            .$isLoading
            .sink { isLoading in
                if (!isLoading) {
                    self.viewModel.startTimer() //start timer for stories
                    self.update()
                }
            }
            .store(in: &cancellables)
        
        self.viewModel.$progress.sink { _ in
            self.update()
        }.store(in: &cancellables)
        
        self.viewModel
            .$storiesEnd
            .sink { isEnd in
                if (isEnd) {
                    self.viewModel.stopTimer()
                    self.viewModel.close()
                }
                else { }
            }
            .store(in: &cancellables)
    }
    
    private func update() {
        blueprintView.element = UIStoryScreen(viewModel: self.viewModel){
            
            $0.onNextTap = {
                self.viewModel.stopTimer()
                self.viewModel.advance(by: 1)
                self.viewModel.startTimer()
            }
            $0.onPreviousTap = {
                self.viewModel.stopTimer()
                self.viewModel.advance(by: -1)
                self.viewModel.startTimer()
            }
            $0.onCloseTap = { slideNum in
                self.viewModel.stopTimer()
                self.viewModel.close()
            }
            $0.onLastSlideNextTap = {
                self.viewModel.stopTimer()
                self.viewModel.close()
            }
            $0.onButtonTap = { url in
                self.viewModel.stopTimer()
                if url != nil {
                    self.routeToURL(url)
                } else {
                    self.viewModel.close()
                }
            }
        }
    }
    
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
        if gesture.state == .began || gesture.state == .changed {
            self.viewModel.freezeTimer()
        } else if gesture.state == .ended {
            self.viewModel.resumeTimer()
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
