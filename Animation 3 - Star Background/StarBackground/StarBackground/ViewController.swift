//
//  ViewController.swift
//  StarBackground
//
//  Created by Jaeyong Lee on 2022/10/23.
//

import UIKit

class ViewController: UIViewController {

    lazy var starBackgroundView = StarBackgroundView(frame: view.bounds)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        view.addSubview(starBackgroundView)
    }
}

final class StarBackgroundView: UIView, CAAnimationDelegate {
    let starSize = CGSize(width: 10, height: 10)
    let starCount: Int = 100
    var starLayers = [CALayer]()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .radial
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.9)
        gradientLayer.endPoint = CGPoint(x: -0.5, y: 0.2)
        gradientLayer.colors = [
            UIColor(named: "blue")?.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)

        for _ in 0..<starCount {
            let astar = CAShapeLayer()
            astar.frame = .init(origin: generateRandomPosition(), size: starSize)
            astar.path = UIBezierPath.starPath.cgPath
            astar.fillColor = UIColor.systemYellow.cgColor
            astar.shadowPath = UIBezierPath.starPath.cgPath
            astar.masksToBounds = false
            astar.shadowColor = UIColor.red.cgColor
            astar.shadowOpacity = 2
            astar.shadowOffset = .zero
            astar.shadowRadius = 4
            starLayers.append(astar)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    override func draw(_ rect: CGRect) {
        starLayers.forEach {
            layer.addSublayer($0)
        }
        
        starLayers.forEach {

            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            let duration: CGFloat = 1
            opacityAnimation.fromValue = 0.2
            opacityAnimation.toValue = 0.8
            opacityAnimation.timeOffset = duration * Double.random(in: 0...1)
            opacityAnimation.duration = duration
            opacityAnimation.repeatCount = .infinity
            opacityAnimation.autoreverses = true
            opacityAnimation.delegate = self
            opacityAnimation.isRemovedOnCompletion = false
            opacityAnimation.fillMode = .forwards
            opacityAnimation.setValue("opacityValue", forKey: "opacity")
            $0.opacity = 0.8



            let colorAnimation = CAKeyframeAnimation(keyPath: "fillColor")
            colorAnimation.duration = duration
            colorAnimation.values = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.systemYellow.cgColor]
            colorAnimation.timeOffset = duration * drand48()
            colorAnimation.repeatCount = .infinity
            colorAnimation.autoreverses = true
            colorAnimation.delegate = self
            colorAnimation.setValue("colorValue", forKey: "color")

            CATransaction.begin()
            $0.add(opacityAnimation, forKey: "opacity")
            $0.add(colorAnimation, forKey: "color")
            CATransaction.commit()
        }
    }

    func generateRandomPosition() -> CGPoint {
        let height = frame.height
        let width = frame.width

        return CGPoint(
            x: CGFloat(arc4random()).truncatingRemainder(dividingBy: width),
            y: CGFloat(arc4random()).truncatingRemainder(dividingBy: height)
        )
    }

}

extension UIBezierPath {
    static var starPath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: .init(x: 10, y: 0))
        path.addLine(to: .init(x: 7.35, y: 6.36))
        path.addLine(to: .init(x: 0.49, y: 6.91))
        path.addLine(to: .init(x: 5.72, y: 11.39))
        path.addLine(to: .init(x: 4.12, y: 18.09))
        path.addLine(to: .init(x: 10, y: 14.5))
        path.addLine(to: .init(x: 15.88, y: 18.09))
        path.addLine(to: .init(x: 14.28, y: 11.39))
        path.addLine(to: .init(x: 19.51, y: 6.91))
        path.addLine(to: .init(x: 12.65, y: 6.36))
        path.close()
        return path
    }
}
