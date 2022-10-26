//
//  ViewController.swift
//  CircleAnimation
//
//  Created by Jaeyong Lee on 2022/10/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let animationViewSize = CGSize(width: 200, height: 200)
        let animationViewFrame = CGRect(
            origin: .init(x: view.center.x - animationViewSize.width/2,
                          y: view.center.y - animationViewSize.height/2),
            size: animationViewSize
        )

        let animationView = AnimationView(
            frame: animationViewFrame,
            size: animationViewSize,
            colors: [.purple, .systemMint]
        )
        view.addSubview(animationView)
        animationView.setup()
    }
}
