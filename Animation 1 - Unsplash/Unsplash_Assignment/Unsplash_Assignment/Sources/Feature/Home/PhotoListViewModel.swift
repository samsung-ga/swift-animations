//
//  HomeViewModel.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/09.
//

import UIKit

final class PhotoListViewModel: BaseViewModel {
    var page: Int = 1
    var indexPathShowing: IndexPath = IndexPath(item: 0, section: 0)
    var photoDatas: [PhotoData] = []
    private let unsplashService = UnsplashService()
    
    func requestPhotos(page: Int = 1, completion: @escaping () -> Void) {
        unsplashService.requestPhoto(byPage: page) { [weak self] in
            guard let self = self else { return }
            let photos = $0.map {
                return PhotoData(id: $0.id,
                                 name: $0.user.name,
                                 width: $0.width,
                                 height: $0.height,
                                 urls: $0.urls)
            }
            
            self.downloadThumbImage(photos) {
                self.photoDatas += photos
                self.page += 1
                completion()
            }
        }
    }
    
    private func downloadThumbImage(_ photos: [PhotoData], completion: @escaping ()->Void) {
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
    }
}
