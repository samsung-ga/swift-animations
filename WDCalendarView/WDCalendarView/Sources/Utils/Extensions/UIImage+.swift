//
//  UIImage+.swift
//  WDCalendarView
//
//  Created by Jaeyong Lee on 2022/11/22.
//

import UIKit

extension UIImage {
    
    convenience init?(_ name: AssetName) {
        self.init(named: name.rawValue)
    }
}
