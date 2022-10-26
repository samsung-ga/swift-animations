//
//  UITextField+.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/12.
//

import UIKit

extension UITextField {
    
    /// placeholder attribute 설정
    /// - Parameters: text, color, font
    func setAttributedPlaceholder(text: String,
                                  color: UIColor,
                                  font: UIFont) {
        let attributedPlaceholder = NSMutableAttributedString(string: text,
                                                              attributes: [NSAttributedString.Key.foregroundColor: color,
                                                                           NSAttributedString.Key.font: font])
        self.attributedPlaceholder = attributedPlaceholder
    }
    
}
