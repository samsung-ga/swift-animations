//
//  SearchCollectionView.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/12.
//

import UIKit

protocol SearchCollectionViewDelegate: AnyObject {
    func fetchMorePage()
    func updateModels(byNewModels models: [PhotoData])
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

final class SearchCollectionView: UICollectionView {
    private let imageFetcher = ImageFetcher()
    
    var indexPathShowing: IndexPath = IndexPath(item: 0, section: 0)
    weak var searchCollectionViewDelegate: SearchCollectionViewDelegate?
    var models: [PhotoData] = [] {
        didSet {
            searchCollectionViewDelegate?.updateModels(byNewModels: models)
        }
    }
    
    convenience init() {
        let layout = ImageContentLayout()
        self.init(frame: .zero, collectionViewLayout: layout)
        showsVerticalScrollIndicator = false
        register(SearchPhotoCollectionViewCell.self)
        layout.imageContentLayouttDelegate = self
        
        self.backgroundColor = .black
        self.delegate = self
        self.dataSource = self
        self.prefetchDataSource = self
        self.delaysContentTouches = false
    }
}

// MARK: - UICollectionViewDataSource
extension SearchCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(SearchPhotoCollectionViewCell.self,
                                                      for: indexPath)
        cell.configure(models[indexPath.item])
        return cell
    }
}

// MARK: ContentLayouttDelegate
extension SearchCollectionView: ImageContentLayouttDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let ratio: CGFloat = CGFloat(models[indexPath.item].height) / CGFloat(models[indexPath.item].width)
        return DeviceInfo.screenWidth / 2 * ratio
    }
}

// MARK: UICollectionViewDelegate
extension SearchCollectionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? SearchPhotoCollectionViewCell else { return }
        
        let updateCellClosure: (PhotoData, Bool) -> Void = { [weak self] (photo, animated) in
            guard let self = self else { return }
            cell.configure(photo, animated: animated)
            self.models[indexPath.item] = photo
        }
        
        imageFetcher.fetchAsync(indexPath: indexPath,
                                data: models[indexPath.item],
                                completion: updateCellClosure)
        
        if indexPath.item == models.count - 2 {
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        imageFetcher.cancelFetch(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        searchCollectionViewDelegate?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight: CGFloat = scrollView.contentSize.height
        let yOffset: CGFloat = scrollView.contentOffset.y
        let heightRemainFromBottom: CGFloat = contentHeight - yOffset

        let frameHeight: CGFloat = scrollView.frame.size.height
        if heightRemainFromBottom < frameHeight * 2.0 {
            searchCollectionViewDelegate?.fetchMorePage()
        }
    }
}

// MARK: UICollectionViewDataSourcePrefetching
extension SearchCollectionView: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            imageFetcher.prefetchData(indexPath: indexPath,
                                      data: models[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            imageFetcher.cancelFetch(indexPath: indexPath)
        }
    }
}
