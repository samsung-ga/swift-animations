//
//  UICollectionView+.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/07.
//

import UIKit

extension UICollectionView {
    /// code로 생성한 cell을 등록해준다.
    /// - Parameters: Cell Type
    func register<T: UICollectionViewCell>(_ : T.Type) {
        let cellClass = String(describing: T.self)
        register(T.self, forCellWithReuseIdentifier: cellClass)
    }
    
    /// 재사용성 Cell 다운캐스팅해준다.
    /// - Parameters: Cell Type, indexPath
    func dequeueReusableCell<T: UICollectionViewCell>(_: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: T.self),
                                             for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(String(describing: T.self))")
        }
        return cell
    }
    
    /// 현재 보이는 cell의 indexPath를 알려준다.
    var visibleCurrentCellIndexPath: IndexPath? {
        var visibleRect = CGRect()
        
        visibleRect.origin = self.contentOffset
        visibleRect.size = self.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        return self.indexPathForItem(at: visiblePoint)
    }
}
