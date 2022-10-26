//
//  IndexPath+.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/14.
//

import Foundation

extension IndexPath {
    func convertItemToSection() -> IndexPath {
        return IndexPath(item: self.section, section: self.item)
    }
}
