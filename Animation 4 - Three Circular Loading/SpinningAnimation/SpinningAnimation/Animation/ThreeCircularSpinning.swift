//
//  Spinning.swift
//  SpinningAnimation
//
//  Created by Jaeyong Lee on 2022/10/20.
//

import UIKit

class ThreeCircularSpinning {

    private var startHeadRadius: CGFloat = 4
    private var radius: CGFloat = 50
    private var endHeadRadius: CGFloat = 4
    func setup(_ layer: CALayer, size: CGSize, colors: [UIColor]) {

        radius = size.width / 4
        endHeadRadius = radius / 6
        startHeadRadius = radius / 12

        let firstSquare = CGRect(
            origin: .init(x: 0, y: radius),
            size: .init(width: 2 * radius, height: 2 * radius)
        )
        let secondSquare = CGRect(
            origin: .init(x: 2*radius, y: radius),
            size: .init(width: 2*radius, height: 2*radius)
        )
        let thirdSquare = CGRect(
            origin: .init(x: radius, y: 0),
            size: .init(width: 2*radius, height: 2*radius)
        )
        let archBezierPath = UIBezierPath(
            arcCenter: .init(x: radius, y: radius),
            radius: radius,
            startAngle: .pi / 4 * 3,
            endAngle: .pi / 4 * 1,
            clockwise: false
        )
        let archBezierPath2 = UIBezierPath(
            arcCenter: .init(x: radius, y: radius),
            radius: radius,
            startAngle: .pi / 4 * 5,
            endAngle: .pi / 4 * 7,
            clockwise: true
        )
        let archBezierPath3 = UIBezierPath(
            arcCenter: .init(x: radius, y: radius),
            radius: radius,
            startAngle: .pi / 4 * 1,
            endAngle: .pi / 4 * 3,
            clockwise: true
        )
        let firstArchLayer = createArchLayer(
            radius: radius,
            color: colors[0].cgColor,
            frame: firstSquare,
            path: archBezierPath
        )
        let secondArchLayer = createArchLayer(
            radius: radius,
            color: colors[1].cgColor,
            frame: secondSquare,
            path: archBezierPath2
        )
        let thirdArchLayer = createArchLayer(
            radius: radius,
            color: colors[2].cgColor,
            frame: thirdSquare,
            path: archBezierPath3
        )
        let endHeadPath = UIBezierPath(
            arcCenter: .init(x: radius - sqrt(radius*radius/2), y: radius + sqrt(radius*radius/2)),
            radius: endHeadRadius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: false
        )
        let endHeadPath2 = UIBezierPath(
            arcCenter: .init(x: radius - sqrt(radius*radius/2), y: radius - sqrt(radius*radius/2)),
            radius: endHeadRadius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: false
        )
        let endHeadPath3 = UIBezierPath(
            arcCenter: .init(x: radius + sqrt(radius*radius/2), y: radius + sqrt(radius*radius/2)),
            radius: endHeadRadius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: false
        )
        let startHeadPath = UIBezierPath(
            arcCenter: .init(x: radius - sqrt(radius*radius/2), y: radius + sqrt(radius*radius/2)),
            radius: startHeadRadius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: false
        )
        let startHeadPath2 = UIBezierPath(
            arcCenter: .init(x: radius - sqrt(radius*radius/2), y: radius - sqrt(radius*radius/2)),
            radius: startHeadRadius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: false
        )
        let startHeadPath3 = UIBezierPath(
            arcCenter: .init(x: radius + sqrt(radius*radius/2), y: radius + sqrt(radius*radius/2)),
            radius: startHeadRadius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: false
        )
        let firstStartHeadlayer = createHeadLayer(
            color: colors[0].cgColor,
            path: startHeadPath
        )
        let secondStartHeadlayer = createHeadLayer(
            color: colors[1].cgColor,
            path: startHeadPath2
        )
        let thirdStartHeadlayer = createHeadLayer(
            color: colors[2].cgColor,
            path: startHeadPath3
        )
        firstArchLayer.addSublayer(firstStartHeadlayer)
        secondArchLayer.addSublayer(secondStartHeadlayer)
        thirdArchLayer.addSublayer(thirdStartHeadlayer)

        let firstHeadlayer = createHeadLayer(
            color: colors[0].withAlphaComponent(0.5).cgColor,
            path: endHeadPath
        )
        let secondHeadlayer = createHeadLayer(
            color: colors[1].withAlphaComponent(0.5).cgColor,
            path: endHeadPath2
        )
        let thirdHeadlayer = createHeadLayer(
            color: colors[2].withAlphaComponent(0.5).cgColor,
            path: endHeadPath3
        )
        firstArchLayer.addSublayer(firstHeadlayer)
        secondArchLayer.addSublayer(secondHeadlayer)
        thirdArchLayer.addSublayer(thirdHeadlayer)

        addRoationAnimation(to: firstArchLayer, direction: true)
        addRoationAnimation(to: secondArchLayer, direction: false)
        addRoationAnimation(to: thirdArchLayer, direction: false)

        layer.addSublayer(firstArchLayer)
        layer.addSublayer(secondArchLayer)
        layer.addSublayer(thirdArchLayer)

    }

    private func createArchLayer(radius: CGFloat, color: CGColor, frame: CGRect, path: UIBezierPath) -> CALayer {

        let archLayer = CAShapeLayer()

        archLayer.frame = frame
        archLayer.path = path.cgPath
        archLayer.fillColor = UIColor.clear.cgColor
        archLayer.strokeColor = color
        archLayer.lineWidth = 3

        return archLayer
    }

    private func createHeadLayer(color: CGColor, path: UIBezierPath) -> CALayer {
        let headLayer = CAShapeLayer()
        headLayer.path = path.cgPath
        headLayer.fillColor = color
        return headLayer
    }
}

extension ThreeCircularSpinning {
    private func addRoationAnimation(to layer: CALayer, direction: Bool) {
        let direction: Double = direction ? 1 : -1
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = direction * 2.0 * .pi
        rotationAnimation.duration = 2.0
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        layer.add(rotationAnimation, forKey: nil)
    }
}
