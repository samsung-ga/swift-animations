//
//  UIColor+.swift
//  WDCalendarView
//
//  Created by Jaeyong Lee on 2022/11/22.
//

import UIKit

extension UIColor {
    class func designSystem(_ color: Palette) -> UIColor? {
        UIColor(named: color.rawValue)
    }
}
