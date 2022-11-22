//
//  UIFont+.swift
//  WDCalendarView
//
//  Created by Jaeyong Lee on 2022/11/22.
//

import UIKit

extension UIFont {
    class func designSystem(weight: UIFont.Weight, size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: weight)
    }
//
//    class func gmarksans(weight: Font.Weight, size: Font.Size) -> UIFont {
//        let font = Font.CustomFont(name: .gmarketsans, weight: weight)
//        return ._font(name: font.name, size: size.rawValue)
//    }
//
//    private static func _font(name: String, size: CGFloat) -> UIFont {
//        guard let font = UIFont(name: name, size: size) else {
//            return .systemFont(ofSize: size)
//        }
//        return font
//    }
}
