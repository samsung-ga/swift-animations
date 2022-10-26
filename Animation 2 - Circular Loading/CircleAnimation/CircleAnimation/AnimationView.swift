//
//  AnimationView.swift
//  CircleAnimation
//
//  Created by Jaeyong Lee on 2022/10/20.
//

import UIKit

final class AnimationView: UIView {
    fileprivate var size: CGSize
    fileprivate var colors: [UIColor]

    init(frame:CGRect, size: CGSize, colors: [UIColor]) {
        self.size = size
        self.colors = colors
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        let animation = RotatingCircle()
        layer.sublayers = nil
        animation.setup(layer, size: size, colors: colors)
    }
}
