//
//  SearchDetailViewController.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/13.
//

import UIKit

protocol SearchDetailViewControllerDelegate: AnyObject {
    func scrollDidScroll()
}

final class SearchDetailViewController: BaseViewController<SearchViewModel> {
    
    weak var transitionAnimator: ImageTransitioAnimator?
    
    weak var searchDetailViewControllerDelegate: SearchDetailViewControllerDelegate?
    weak var imageTransitionPresentationControllerDelegate: ImageTransitionPresentationControllerDelegate?
    
    lazy var collectionView: HorizontalPhotoCollectionView = {
        let collectionView = HorizontalPhotoCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.models = viewModel.photoDatas
        collectionView.indexPathShowing = viewModel.indexPathShowing
        collectionView.horizontalPhotoCollectionViewDelegate = self
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let model = viewModel.photoDatas[viewModel.indexPathShowing.item]
        imageTransitionPresentationControllerDelegate?.setNavigationName(model.name)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchDetailViewControllerDelegate?.scrollDidScroll()
    }
    
    override func layout() {
        super.layout()
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}

// MARK: HorizontalPhotoCollectionViewDelegate
extension SearchDetailViewController: HorizontalPhotoCollectionViewDelegate {
    
    func updateLastIndexPath(goBackWith indexPath: IndexPath) {
        transitionAnimator?.targetData = viewModel.photoDatas[indexPath.item]
        transitionAnimator?.indexPath = indexPath
        viewModel.indexPathShowing = indexPath
        
        searchDetailViewControllerDelegate?.scrollDidScroll()
    }
    
    func updateModels(byModels models: [PhotoData]) {
        viewModel.photoDatas = models
    }

    func scrollDidScroll(toItem itemOfIndexPath: Int) {
        let model = viewModel.photoDatas[itemOfIndexPath]
        imageTransitionPresentationControllerDelegate?.setNavigationName(model.name)
    }
}
