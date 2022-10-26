//
//  BlackholeView.swift
//  BlackHoleRefreshAnimation
//
//  Created by Jaeyong Lee on 2022/10/22.
//

import UIKit

protocol BlackholeDelegate: AnyObject {
    func blackholeViewDidRefresh(_ blackholeView: BlackholeView)
}
final class BlackholeView: UIView, UIScrollViewDelegate {

    let astronautLayer = CALayer()
    let scrollView: UIScrollView
    var isLoading: Bool = false
    var contentOffsetY: CGFloat = 0
    weak var delegate: BlackholeDelegate?
    var startPath: UIBezierPath = .init()
    var endPath: UIBezierPath = .init()

    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
        scrollView.delegate = self

        let backgroundImageView = UIImageView(image: .init(named: "blackhole_total"))
        backgroundImageView.frame = bounds
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        addSubview(backgroundImageView)

        startPath = banglebanglePath()
        endPath = leavePath()

        let astronautImage = UIImage(named: "astronaut")!
        astronautLayer.contents = astronautImage.cgImage
        astronautLayer.frame = CGRect(origin: .zero, size: .init(width: 70, height: 70))
        astronautLayer.position = startPath.firstPoint()!
        layer.addSublayer(astronautLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 { return }
        let offsetY = CGFloat(max(-scrollView.contentOffset.y, 0))
        self.contentOffsetY = min(max(offsetY/170, 0), 1)
        print(contentOffsetY)
        if !isLoading {
            changeContentOffset(self.contentOffsetY)
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.contentOffset.y > 0 { return }

        if !isLoading && contentOffsetY >= 1 {
            delegate?.blackholeViewDidRefresh(self)
            beginLoading()
        }
    }

    func beginLoading() {
        isLoading = true

        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset = .init(top: 160, left: 0, bottom: 0, right: 0)
        }

//        let shaking = CAKeyframeAnimation(keyPath: "position.x")
//        shaking.values = [0, -10, 10, -10, 0]
//        shaking.keyTimes = [0, 0.12, 0.32, 0.52, 0.72]
//        shaking.duration = 0.72
//        shaking.isAdditive = true
//        shaking.isRemovedOnCompletion = false
//        shaking.fillMode = .forwards
//        shaking.repeatCount = 3
//        astronautLayer.add(shaking, forKey: nil)
//        astronautLayer.position = startPath.currentPoint

        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.toValue = Double.pi * 2
        rotate.fromValue = 0
        rotate.repeatCount = 2
        rotate.isRemovedOnCompletion = false
        rotate.fillMode = .forwards
        rotate.duration = 1
        astronautLayer.add(rotate, forKey: nil)

    }

    func endLoading() {
        isLoading = false

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.scrollView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        }

        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.path = endPath.cgPath
        pathAnimation.keyTimes = [0 ,0.4]
        pathAnimation.duration = 1.0
        astronautLayer.add(pathAnimation, forKey: nil)

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 0
        scaleAnimation.duration = 0.4
        astronautLayer.add(scaleAnimation, forKey: nil)
    }

    func changeContentOffset(_ value: CGFloat) {
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.path = startPath.cgPath
        pathAnimation.timingFunctions = [CAMediaTimingFunction(name: .easeOut)]
        pathAnimation.beginTime = 0.1
        pathAnimation.duration = 1.0
        pathAnimation.timeOffset = CFTimeInterval() + Double(value)
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.fillMode = .forwards

        astronautLayer.add(pathAnimation, forKey: nil)
        astronautLayer.position = startPath.currentPoint

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = max(0.5, value)
        scaleAnimation.beginTime = 0.1
        scaleAnimation.duration = 1.0
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.fillMode = .forwards

        astronautLayer.add(scaleAnimation, forKey: nil)
    }

    private func banglebanglePath() -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 40, y: frame.minY + 130))
        bezierPath.addCurve(to: CGPoint(x: 250.0, y: 142.5), controlPoint1: CGPoint(x: 67.5, y: 160.5), controlPoint2: CGPoint(x: 113.5, y: 155))

        return bezierPath
    }

    private func leavePath() -> UIBezierPath {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 250.0, y: 142.5))
        bezierPath.addLine(to: CGPoint(x: 120, y: -100))
        return bezierPath
    }
}

extension CGPath {
    func forEach(body: @convention(block) @escaping (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        self.apply(info: unsafeBody, function: callback)
    }
}

// Finds the first point in a path
extension UIBezierPath {
    func firstPoint() -> CGPoint? {
        var firstPoint: CGPoint? = nil

        self.cgPath.forEach { element in
            // Just want the first one, but we have to look at everything
            guard firstPoint == nil else { return }
            assert(element.type == .moveToPoint, "Expected the first point to be a move")
            firstPoint = element.points.pointee
        }
        return firstPoint
    }
}
