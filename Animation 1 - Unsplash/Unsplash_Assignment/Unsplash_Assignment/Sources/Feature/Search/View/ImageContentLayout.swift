//
//  ContentCollectionViewLayout.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/13.
//

import UIKit

protocol ImageContentLayouttDelegate: AnyObject {
  func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}
  
class ImageContentLayout: UICollectionViewLayout {

    weak var imageContentLayouttDelegate: ImageContentLayouttDelegate!
    
    fileprivate let numberOfColumns = 2
    fileprivate var contentBounds = CGRect.zero
    fileprivate var contentHeight: CGFloat = 0
    fileprivate var contentWidth: CGFloat {
      guard let collectionView = collectionView else {
          return 0
      }
      return collectionView.bounds.width
    }
    
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }

        cachedAttributes.removeAll()
        contentHeight = 0
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        let count: Int         = collectionView.numberOfItems(inSection: 0)
        let cellWidth: CGFloat = DeviceInfo.screenWidth / 2
        var column: Int        = 0
        var currentIndex: Int  = 0
        
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
          xOffset.append(CGFloat(column) * cellWidth)
        }
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        while currentIndex < count {
            
            let indexPath = IndexPath(item: currentIndex, section: 0)
            
            let photoHeight = imageContentLayouttDelegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: cellWidth, height: photoHeight)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cachedAttributes.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + photoHeight
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
            currentIndex += 1
        }
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributesArray = [UICollectionViewLayoutAttributes]()

        guard let lastIndex = cachedAttributes.indices.last,
              let firstMatchIndex = binSearch(rect, start: 0, end: lastIndex) else { return attributesArray }

        for attributes in cachedAttributes[..<firstMatchIndex].reversed() {
            guard attributes.frame.maxY >= rect.minY else { break }
            attributesArray.append(attributes)
        }

        for attributes in cachedAttributes[firstMatchIndex...] {
            guard attributes.frame.minY <= rect.maxY else { break }
            attributesArray.append(attributes)
        }

        return attributesArray
    }

    func binSearch(_ rect: CGRect, start: Int, end: Int) -> Int? {
        if end < start { return nil }
        
        let mid = (start + end) / 2
        let attr = cachedAttributes[mid]
        
        if attr.frame.intersects(rect) {
            return mid
        } else {
            if attr.frame.maxY < rect.minY {
                return binSearch(rect, start: (mid + 1), end: end)
            } else {
                return binSearch(rect, start: start, end: (mid - 1))
            }
        }
    }
}
