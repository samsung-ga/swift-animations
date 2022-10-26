//
//  BaseView.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/12.
//

import UIKit

class BaseView: UIView, CodeBasedProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    init() {
        super.init(frame: .zero)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() { }
    
    func layout() { }
}
