//
//  BaseCollectionViewCell.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/07.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, CodeBasedProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() { }
    
    func layout() { }
    
}
