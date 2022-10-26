//
//  UnsplashImageView.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/14.
//

import UIKit

class UnsplashImageView: UIImageView {
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    private var layoutDidSet: Bool = false
    var photoData: PhotoData?
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if layoutDidSet == false {
            layoutDidSet = true
            self.addSubview(visualEffectView)
            NSLayoutConstraint.activate([
                visualEffectView.widthAnchor.constraint(equalTo: self.widthAnchor),
                visualEffectView.heightAnchor.constraint(equalTo: self.heightAnchor),
                visualEffectView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                visualEffectView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        }
    }
    
    func setPhoto(animated: Bool) {
        if let image = photoData?.image {
            DispatchQueue.main.async { [weak self] in
                self?.setVisualEffectView(animated: animated)
                self?.image = image
            }
        } else {
            if let thumbImage = photoData?.thumbImage {
                DispatchQueue.main.async { [weak self] in
                    self?.image = thumbImage
                }
            }
        }
    }
    
    func resetVisualEffectView() {
        visualEffectView.effect = UIBlurEffect(style: .light)
    }
    
    private func setVisualEffectView(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.33) {
                self.visualEffectView.effect = nil
            }
        } else {
            self.visualEffectView.effect = nil
        }
    }
}
