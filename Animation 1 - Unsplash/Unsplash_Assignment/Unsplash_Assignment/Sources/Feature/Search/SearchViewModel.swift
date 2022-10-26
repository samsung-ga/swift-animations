//
//  SearchViewModel.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/12.
//

import UIKit

class SearchViewModel: BaseViewModel {
    private enum ViewState {
        case loading
        case none
    }
    var totalPage: Int = 1
    var page: Int = 1
    var beforeKeyowrd: String = ""
    var photoDatas: [PhotoData] = []
    var indexPathShowing: IndexPath = IndexPath(item: 0, section: 0)
    private var state: ViewState = .none
    private let unsplashService = UnsplashService()
    
    func searchPhotos(byKeyword keyword: String,
                      completion: @escaping ()-> Void) {
        guard state == .none else { return }
        
        page = 1
        beforeKeyowrd = keyword
        
        state = .loading
        unsplashService.requestSearch(byKeyword: keyword,
                                      page: page) { [weak self] in
            guard let self = self else { return }
            self.totalPage = $0.totalPages
            let photos = $0.results.map {
                PhotoData(id: $0.id,
                          name: $0.user.name,
                          width: $0.width,
                          height: $0.height,
                          urls: $0.urls)
            }
            self.downloadThumbImage(photos, completion: {
                self.photoDatas = photos
                self.page = 2
                self.state = .none
                completion()
            })
        }
    }
    
    func loadMore(completion: @escaping ()-> Void) {
        guard state == .none else { return }
        guard page <= totalPage else { return }
        
        state = .loading
        unsplashService.requestSearch(byKeyword: beforeKeyowrd,
                                      page: page) { [weak self] in
            guard let self = self else { return }
            self.totalPage = $0.totalPages
            let photos = $0.results.map {
                PhotoData(id: $0.id,
                          name: $0.user.name,
                          width: $0.width,
                          height: $0.height,
                          urls: $0.urls)
            }
            self.downloadThumbImage(photos, completion: {
                self.photoDatas += photos
                self.page += 1
                self.state = .none
                completion()
            })
        }
    }
    private func downloadThumbImage(_ photos: [PhotoData],
                                    completion: @escaping ()->Void) {
        var count: Int = 0
        photos.forEach { photo in
            ImageService.shared.downloadImage(path: photo.urls.thumb) { data in
                count += 1
                photo.thumbImage = UIImage(data: data)
                if count == photos.count {
                    completion()
                }
            }
        }
        if photos.count == 0 { completion() }
    }
    
    private func checkLoadMoreRequest(_ keyword: String) -> String {
        if keyword.isEmpty {
            return beforeKeyowrd
        }
        return keyword
    }
    
}
