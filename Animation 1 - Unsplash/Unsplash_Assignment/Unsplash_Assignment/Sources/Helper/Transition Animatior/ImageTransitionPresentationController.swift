//
//  ImageTransitionPresentationController.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/11.
//

import UIKit

protocol ImageTransitionPresentationControllerDelegate: AnyObject {
    func setNavigationName(_ name: String)
}

class ImageTransitionPresentationController: UIPresentationController {

    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    private lazy var navigationBar: NaviBar = {
        let naviBar = NaviBar(frame: .zero)
        naviBar.translatesAutoresizingMaskIntoConstraints = false
        naviBar.setupTitle()
        naviBar.setupBackItemImage()
        naviBar.setupShareItemImage()
        naviBar.navigationBarDelegate = self
        return naviBar
    }()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        
        if let detailViewController = presentedViewController as? DetailViewController {
            detailViewController.imageTransitionPresentationControllerDelegate = self
        } else if let searchDetailViewController = presentedViewController as? SearchDetailViewController {
            searchDetailViewController.imageTransitionPresentationControllerDelegate = self
        }
        
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        layout()
        guard let coordinator = presentedViewController.transitionCoordinator else {
            self.animateStart()
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.animateStart()
            self.containerView?.bringSubviewToFront(self.navigationBar)
            self.containerView?.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        guard let coordinator = presentingViewController.transitionCoordinator else {
            self.animateStart(direction: false)
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.animateStart(direction: false)
            self.containerView?.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func layout() {
        setupNavigationBar()
        setupBackgroundView()
    }
    
    private func setupNavigationBar() {
        guard let containerView = containerView else  { return }
        
        containerView.addSubview(navigationBar)
        navigationBar.alpha = 0
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private func setupBackgroundView() {
        guard let containerView = containerView else  { return }
        
        containerView.insertSubview(backgroundView, at: 0)
        backgroundView.alpha = 0
        backgroundView.frame = containerView.frame
        containerView.layoutIfNeeded()
    }
    
    private func animateStart(direction: Bool = true) {
        let alpha: CGFloat = direction ? 1 : 0
        backgroundView.alpha = alpha
        navigationBar.alpha = alpha
    }
}

// MARK: NaviBarDelegate
extension ImageTransitionPresentationController: NaviBarDelegate {
    func tapLeftItem() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: ImageTransitionPresentationControllerDelegate
extension ImageTransitionPresentationController: ImageTransitionPresentationControllerDelegate {
    func setNavigationName(_ name: String) {
        navigationBar.setupTitle(name)
    }
}
