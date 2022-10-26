//
//  EmptySearchView.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/12.
//

import UIKit

class SearchEmptyView: BaseView {
    private let informationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No photos!!!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        return label
    }()
    
    override func attribute() {
        super.attribute()
        
        backgroundColor = .black
    }
    override func layout() {
        super.layout()
        
        addSubview(informationLabel)
        NSLayoutConstraint.activate([
            informationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            informationLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
