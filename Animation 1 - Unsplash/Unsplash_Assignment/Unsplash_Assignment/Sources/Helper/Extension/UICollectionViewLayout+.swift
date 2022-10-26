//
//  UICollectionViewLayout+.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/13.
//

import UIKit

extension UICollectionViewLayout {

    /// CompositionalLayout  화면 1/3 차지
    static let grid = UICollectionViewCompositionalLayout { section, environment in
        let margin = 1.0
        let numberOfColumn = 2

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: margin,
                                                     leading: margin,
                                                     bottom: margin,
                                                     trailing: margin)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: numberOfColumn)

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

}
