//
//  ViewController.swift
//  KeyMasking
//
//  Created by Jaeyong Lee on 2022/10/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let size = CGSize(width: 200, height: 200)
        let frame = CGRect(
            origin: .init(x: view.center.x-size.width/2,
                          y: view.center.y-size.height/2),
            size: size
        )

        let keyView = MaskingView(frame: frame, colors: [.purple])
        view.addSubview(keyView)
    }
}

class MaskingView: UIView {

    init(frame: CGRect, colors: [UIColor]) {
        self.colors = colors
        super.init(frame: frame)
        backgroundColor = .purple
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var colors: [UIColor]

    override func draw(_ rect: CGRect) {
        let maskLayer = CAShapeLayer()
        let bezierPath = UIBezierPath()
        let handleWidth: CGFloat = 100
        let bodyWidth: CGFloat = 40

        let handleRect = CGRect(origin: .init(x: 50, y: 0), size: .init(width: handleWidth, height: handleWidth))
        let keyPath = UIBezierPath(ovalIn: handleRect)
        keyPath.move(to: .init(x: 50+(100-bodyWidth)/2, y: 100))
        keyPath.addLine(to: .init(x: 50+(100-bodyWidth)/2, y: bounds.height))
        keyPath.addLine(to: .init(x: 50+(100+bodyWidth)/2, y: bounds.height))
        keyPath.addLine(to: .init(x: 50+(100+bodyWidth)/2, y: 100))
        keyPath.addArc(withCenter: .init(x: 100, y: 50),
                          radius: 50,
                          startAngle: 66.42 * .pi / 180,
                          endAngle: 113.58 * .pi / 180,
                          clockwise: true)
        keyPath.close()

        let rightTeethRect1 = CGRect(origin: .init(x: 50+bodyWidth+(100-bodyWidth)/2, y: 120), size: .init(width: 30, height: 20))
        let rightPath1 = UIBezierPath(rect: rightTeethRect1)
        let rightTeethRect2 = CGRect(origin: .init(x: 50+bodyWidth+(100-bodyWidth)/2, y: 150), size: .init(width: 20, height: 20))
        let rightPath2 = UIBezierPath(rect: rightTeethRect2)

        let leftTeethRect = CGRect(origin: .init(x: 50+(100-bodyWidth)/2-20, y: 130), size: .init(width: 20, height: 20))
        let leftPath = UIBezierPath(rect: leftTeethRect)
        let roundRect = CGRect(origin: .init(x: 70, y: 20), size: .init(width: 60, height: 60))
        let roundPath = UIBezierPath(ovalIn: roundRect)

        maskLayer.fillRule = .evenOdd

        bezierPath.append(roundPath)
        bezierPath.append(keyPath)
        bezierPath.append(rightPath1)
        bezierPath.append(rightPath2)
        bezierPath.append(leftPath)

        maskLayer.path = bezierPath.cgPath
        layer.mask = maskLayer
    }
}
