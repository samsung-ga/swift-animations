//
//  SearchViewController.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/07.
//

import UIKit

class SearchViewController: BaseViewController<SearchViewModel> {
    private let transitionAnimator = ImageTransitioAnimator()
    
    private lazy var searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarDelegate = self
        searchBar.setReturnKeyType(.search)
        return searchBar
    }()
    private let searchEmptyView: SearchEmptyView = {
        let emptyView = SearchEmptyView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        return emptyView
    }()
    lazy var collectionView: SearchCollectionView = {
        let collectionView = SearchCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.searchCollectionViewDelegate = self
        return  collectionView
    }()
    override func layout() {
        super.layout()
        
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(searchEmptyView)
        NSLayoutConstraint.activate([
            searchEmptyView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            searchEmptyView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            searchEmptyView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            searchEmptyView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
    }
    
    override func attribute() {
        setupSearchEmptyView()
    }
    
    private func setupSearchEmptyView() {
        searchEmptyView.isHidden = false
    }
}

// MARK: SearchBarDelegate
extension SearchViewController: SearchBarDelegate {
    func tapSearch(_ keyword: String) {
        searchEmptyView.isHidden = true
        viewModel.searchPhotos(byKeyword: keyword) { [weak self] in
            guard let self = self else { return }
            self.collectionView.models = self.viewModel.photoDatas
            DispatchQueue.main.async {
                self.searchEmptyView.isHidden = !self.viewModel.photoDatas.isEmpty
                self.collectionView.reloadData()
            }
        }
    }

    func tapCancelButton() {
        searchEmptyView.isHidden = false
        searchBar.text = ""
        viewModel.photoDatas = []
        collectionView.models = []
        collectionView.reloadData()
    }
}

extension SearchViewController: SearchCollectionViewDelegate {
    func updateModels(byNewModels models: [PhotoData]) {
        viewModel.photoDatas = models
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.indexPathShowing = indexPath
        
        let detailViewController = SearchDetailViewController(viewModel)

        transitionAnimator.indexPath = indexPath
        transitionAnimator.superViewcontroller = detailViewController
        transitionAnimator.targetData = viewModel.photoDatas[indexPath.item]

        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = transitionAnimator
        detailViewController.transitionAnimator = transitionAnimator
        detailViewController.searchDetailViewControllerDelegate = self
        self.present(detailViewController,
                     animated: true,
                     completion: nil)
    }
    
    func fetchMorePage() {
        viewModel.loadMore { [weak self] in
            self?.collectionView.models = self?.viewModel.photoDatas ?? []
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
}

extension SearchViewController: SearchDetailViewControllerDelegate {
    func scrollDidScroll() {
        collectionView.scrollToItem(at: viewModel.indexPathShowing,
                                    at: .centeredVertically,
                                    animated: false)
    }
}
