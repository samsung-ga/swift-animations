//
//  LoadingIndicator.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/14.
//

import UIKit

final class LoadingIndicator: BaseView {
    private static let shared: LoadingIndicator = LoadingIndicator()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func layout() {
        super.layout()
        
        addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    class func show() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
                  return
              }
        
        window.addSubview(shared)
        shared.center = window.center
    }
    
    class func hide() {
        DispatchQueue.main.async {
            shared.removeFromSuperview()
        }
    }
    
}
