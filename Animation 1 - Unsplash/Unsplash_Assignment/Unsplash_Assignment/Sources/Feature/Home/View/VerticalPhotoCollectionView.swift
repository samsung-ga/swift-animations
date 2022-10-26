//
//  HomeCollectionView.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/07.
//

import UIKit

protocol VerticalPhotoCollectionViewDelegate: AnyObject {
    func fetchMorePage()
    func updateModels(byModels models: [PhotoData])
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func scrollViewDidScroll()  // TODO: 탭 애니메이션
}

final class VerticalPhotoCollectionView: UICollectionView {
    private var lastContentOffset: CGFloat = 0
    private let imageFetcher = ImageFetcher()
    
    weak var verticalPhotoCollectionViewDelegate: VerticalPhotoCollectionViewDelegate? 
    var models: [PhotoData] = [] {
        didSet { verticalPhotoCollectionViewDelegate?.updateModels(byModels: models) }
    }
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        self.init(frame: .zero, collectionViewLayout: layout)
        showsVerticalScrollIndicator = false
        register(PhotoCollectionViewCell.self)
        
        self.backgroundColor = .black
        self.delegate = self
        self.dataSource = self
        self.prefetchDataSource = self
        self.delaysContentTouches = false
    }
}

// MARK: - UICollectionViewDataSource
extension VerticalPhotoCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(PhotoCollectionViewCell.self,
                                                      for: indexPath)
        cell.configure(models[indexPath.item])
        return cell
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension VerticalPhotoCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item: PhotoData     = models[indexPath.item]
        let ratio: CGFloat      = CGFloat(item.height) / CGFloat(item.width)
        let cellHeight: CGFloat = collectionView.frame.width * ratio
        
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
}

// MARK: - UICollectionViewDelegate
extension VerticalPhotoCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoCollectionViewCell else { return }
        
        let updateCellClosure: (PhotoData, Bool) -> Void = { [weak self] (photo, animated) in
            guard let self = self else { return }
            cell.configure(photo, animated: animated)
            self.models[indexPath.item] = photo
        }
        
        imageFetcher.fetchAsync(indexPath: indexPath,
                                data: models[indexPath.item],
                                completion: updateCellClosure)

        if indexPath.item == models.count - 3 {
            verticalPhotoCollectionViewDelegate?.fetchMorePage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        imageFetcher.cancelFetch(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        verticalPhotoCollectionViewDelegate?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffset = scrollView.contentOffset
        
        if lastContentOffset < currentContentOffset.y {
            verticalPhotoCollectionViewDelegate?.scrollViewDidScroll()
        }
        lastContentOffset = currentContentOffset.y
    }
}

// MARK: UICollectionViewDataSourcePrefetching
extension VerticalPhotoCollectionView: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            imageFetcher.prefetchData(indexPath: indexPath,
                                   data: models[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            imageFetcher.cancelFetch(indexPath: indexPath)
        }
    }
}

