//
//  ToastView.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/14.
//

import UIKit

class ToastView: BaseView {
    private static let shared: ToastView = ToastView()
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    override func attribute() {
        super.attribute()
        
        backgroundColor = .darkGray
        layer.cornerRadius = 15
    }
    
    override func layout(){
        super.layout()
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 200),
            heightAnchor.constraint(equalToConstant: 50)
        ])
        
        self.addSubview(label)
        label.center = center
        
    }
    
    class func show(text: String) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
                  return
              }
        
        window.addSubview(shared)
        shared.center = window.center
        shared.alpha = 0
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: {
            shared.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.4,
                           delay: 2.0,
                           options: [.curveEaseOut],
                           animations: {
                shared.alpha = 0
            }, completion: { _ in
                DispatchQueue.main.async {
                    shared.removeFromSuperview()
                }
            })
        })
    }
}

