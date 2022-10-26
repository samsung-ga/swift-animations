//
//  ViewController.swift
//  SpinningAnimation
//
//  Created by Jaeyong Lee on 2022/10/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let size = CGSize(width: 200, height: 150)
        let frame = CGRect(
            origin: .init(x: view.center.x-size.width/2,
                          y: view.center.y-size.height/2),
            size: size
        )

        let animationView = AnimationView(frame: frame, colors: [
            .systemMint,
            .systemYellow,
            .systemPink
        ])
        view.addSubview(animationView)
        animationView.setup()
    }
}

class AnimationView: UIView {

    var colors: [UIColor]

    init(frame: CGRect, colors: [UIColor]) {
        self.colors = colors
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        let animation = ThreeCircularSpinning()
        layer.sublayers = nil
        animation.setup(layer, size: bounds.size, colors: colors)
    }
}
