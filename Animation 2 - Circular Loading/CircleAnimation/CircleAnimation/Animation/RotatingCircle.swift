//
//  RotatingCircle.swift
//  CircleAnimation
//
//  Created by Jaeyong Lee on 2022/10/20.
//

import UIKit

class RotatingCircle {

    func setup(_ layer: CALayer, size: CGSize, colors: [UIColor]) {

        let dotNumber: CGFloat = 12
        // 점의 지름 크기
        let diameter = size.width / dotNumber

        let dot = CALayer()
        let startFrame = CGRect(
            x: (layer.bounds.width - diameter) / 2 + diameter * 3,
            y: (layer.bounds.height - diameter) / 2,
            width: diameter,
            height: diameter
        )

        dot.backgroundColor = colors[0].cgColor
        dot.cornerRadius = diameter / 2
        dot.frame = startFrame

        let replicator = CAReplicatorLayer()
        replicator.frame = layer.bounds
        replicator.instanceCount = Int(dotNumber)
        replicator.instanceDelay = 1 / dotNumber

        let angle = (-2.0 * .pi) / Double(replicator.instanceCount)
        replicator.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        layer.addSublayer(replicator)
        replicator.addSublayer(dot)

//        let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
//        fadeOutAnimation.fromValue = 1
//        fadeOutAnimation.toValue = 0
//        fadeOutAnimation.repeatCount = .infinity
//        fadeOutAnimation.autoreverses = true
//        fadeOutAnimation.duration = 0.5
//        dot.add(fadeOutAnimation, forKey: nil)

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.toValue = 0.4
        scaleAnimation.duration = 0.5
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        dot.add(scaleAnimation, forKey: nil)

        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.toValue = 2.0 * .pi
        rotationAnimation.duration = 6.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        replicator.add(rotationAnimation, forKey: nil)

        if colors.count > 1 {
            let colorAnimation = CAKeyframeAnimation(keyPath: "backgroundColor") 
            colorAnimation.values = colors.map { $0.cgColor }
            colorAnimation.duration = 2
            colorAnimation.autoreverses = true
            colorAnimation.repeatCount = .infinity
            dot.add(colorAnimation, forKey: nil)
        }
    }
}
