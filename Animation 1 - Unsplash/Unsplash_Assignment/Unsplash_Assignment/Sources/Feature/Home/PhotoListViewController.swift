//
//  HomeViewController.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/07.
//

import UIKit

protocol PhotoListViewControllerDelegate: AnyObject {
    func scrollDidScroll()
}

final class PhotoListViewController: BaseViewController<PhotoListViewModel> {
    private let transitionAnimator = ImageTransitioAnimator()
    lazy var collectionView: VerticalPhotoCollectionView = {
        let collectionView = VerticalPhotoCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.verticalPhotoCollectionViewDelegate = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.requestPhotos() { [weak self] in
            self?.collectionView.models = self?.viewModel.photoDatas ?? []
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func layout() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PhotoListViewController: VerticalPhotoCollectionViewDelegate {

    func fetchMorePage() {
        viewModel.requestPhotos(page: viewModel.page) { [weak self] in
            self?.collectionView.models = self?.viewModel.photoDatas ?? []
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func updateModels(byModels models: [PhotoData]) {
        viewModel.photoDatas = models
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.indexPathShowing = indexPath
        
        let detailViewController = DetailViewController(viewModel)
        
        transitionAnimator.indexPath = indexPath
        transitionAnimator.superViewcontroller = detailViewController
        transitionAnimator.targetData = viewModel.photoDatas[indexPath.item]
        
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = transitionAnimator
        detailViewController.transitionAnimator = transitionAnimator
        detailViewController.photoListViewControllerDelegate = self
        self.present(detailViewController,
                     animated: true,
                     completion: nil)
    }
    
    func scrollViewDidScroll() {

    }
}

extension PhotoListViewController: PhotoListViewControllerDelegate {
    func scrollDidScroll() {
        collectionView.scrollToItem(at: viewModel.indexPathShowing,
                                    at: .centeredVertically,
                                    animated: false)
    }
}
