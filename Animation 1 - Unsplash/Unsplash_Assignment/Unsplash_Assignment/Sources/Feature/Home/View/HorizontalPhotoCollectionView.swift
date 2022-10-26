//
//  HorizontalPhotoCollectionView.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/11.
//

import UIKit

protocol HorizontalPhotoCollectionViewDelegate: AnyObject {
    func updateLastIndexPath(goBackWith indexPath: IndexPath)
    func updateModels(byModels models: [PhotoData])
    func scrollDidScroll(toItem itemOfIndexPath: Int)
}

final class HorizontalPhotoCollectionView: UICollectionView {
    private var isFirstSet: Bool = true
    private let imageFetcher = ImageFetcher()
    
    var indexPathShowing: IndexPath = IndexPath(item: 0, section: 0)
    weak var horizontalPhotoCollectionViewDelegate: HorizontalPhotoCollectionViewDelegate?
    var models: [PhotoData] = [] {
        didSet { horizontalPhotoCollectionViewDelegate?.updateModels(byModels: models) }
    }
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        self.init(frame: .zero, collectionViewLayout: layout)
        showsVerticalScrollIndicator = false
        register(PhotoCollectionViewCell.self)
        
        self.isPagingEnabled = true
        self.backgroundColor = .black
        self.dataSource = self
        self.delegate = self
        self.prefetchDataSource = self
    }
}

// MARK: UICollectionViewDataSource
extension HorizontalPhotoCollectionView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return models.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PhotoCollectionViewCell.self,
                                                      for: indexPath)
        cell.configure(models[indexPath.section],
                       isDetail: true)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HorizontalPhotoCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let collectionViewHeight: CGFloat = collectionView.frame.height
        let item: PhotoData     = models[section]
        let ratio: CGFloat      = CGFloat(item.height) / CGFloat(item.width)
        let cellHeight: CGFloat = collectionView.frame.width * ratio
        let inset: CGFloat      = (collectionViewHeight - cellHeight) / 2
        
        return UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item: PhotoData     = models[indexPath.section]
        let ratio: CGFloat      = CGFloat(item.height) / CGFloat(item.width)
        let cellHeight: CGFloat = collectionView.frame.width * ratio
        
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
}

// MARK: - UICollectionViewDelegate
extension HorizontalPhotoCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoCollectionViewCell else { return }
        
        if isFirstSet {
            isFirstSet = false
            let startIndexPath = indexPathShowing.convertItemToSection()
            collectionView.scrollToItem(at: startIndexPath,
                                        at: .centeredVertically,
                                        animated: false)
        }
        
        let updateCellClosure: (PhotoData, Bool) -> Void = { [weak self] photo, animated in
            guard let self = self else { return }
            cell.configure(photo, isDetail: true, animated: animated)
            self.models[indexPath.section] = photo
        }
        
        imageFetcher.fetchAsync(indexPath: indexPath,
                                data: models[indexPath.section],
                                completion: updateCellClosure)

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        imageFetcher.cancelFetch(indexPath: indexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let visibleCellIndexPath = self.visibleCurrentCellIndexPath {
            let convertedIndexPath = visibleCellIndexPath.convertItemToSection()
            horizontalPhotoCollectionViewDelegate?.updateLastIndexPath(goBackWith: convertedIndexPath)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndexPath = scrollView.contentOffset.x / DeviceInfo.screenWidth
        let currentOffset = scrollView.contentOffset.x.truncatingRemainder(dividingBy: DeviceInfo.screenWidth)
        
        if currentOffset > DeviceInfo.screenWidth / 2 {
            horizontalPhotoCollectionViewDelegate?.scrollDidScroll(toItem: Int(currentIndexPath) + 1)
        } else {
            horizontalPhotoCollectionViewDelegate?.scrollDidScroll(toItem: Int(currentIndexPath))
        }
    }
}

// MARK: UICollectionViewDataSourcePrefetching
extension HorizontalPhotoCollectionView: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            imageFetcher.prefetchData(indexPath: indexPath,
                                   data: models[indexPath.section])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            imageFetcher.cancelFetch(indexPath: indexPath)
        }
    }
}

