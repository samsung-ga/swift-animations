//
//  ImageCacheManager.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/10.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    /// cache에서 꺼내오기
    func getImage(byImageURL imageURL: String) -> UIImage? {
        return cache.object(forKey: imageURL as NSString)
    }
    
    /// cache에 저장하기
    func storeImage(byImageURL imageURL: String, withImage image: UIImage?) {
        cache.setObject(image ?? UIImage(), forKey: imageURL as NSString)
    }
    
    
    // MARK: 캐시에서 이미지 다운로드 비동기 처리 잔유물...
    /*
    private var fetching: [String] = []
    func fetchImage(byImageURL imageURL: String, completion: ((UIImage?)->Void)? = nil) {
        if let image = getImage(byImageURL: imageURL) {
            completion?(image)
            return
        }
        guard !fetching.contains(imageURL) else { return }
        fetching.append(imageURL)
        DispatchQueue.global(qos: .background).async {
            ImageService.shared.downloadImage(path: imageURL) {[weak self] data in
                guard let self = self else { return }
                let image = UIImage(data: data)
                self.storeImage(byImageURL: imageURL, withImage: image)
                completion?(image)
            }
        }
    }
     
     // MARK: Diffable Datasource를 적용하면서 이미지 렌더링을 캐시에서 처리하게 되면서 필요한 메소드들

     private var fetchingImages: [String] = []
     private var completions: [String: ImageCompletion] = [:]

     func prefetch(for item: PhotoData, completion: @escaping ImageCompletion) {
         let imageURL: String = item.urls.regular
         guard getImage(byImageURL: imageURL) == nil,
               fetchingImages.contains(imageURL) else {
                   return
               }

         fetchingImages.append(imageURL)
         completions[imageURL] = completion

         ImageService.shared.downloadImage(path: imageURL) { [weak self] data in
             guard let self = self else { return }
             guard let completion = self.completions[imageURL] else {
                 completion(item, nil)
                 return
             }

             let image = UIImage(data: data)
             self.storeImage(byImageURL: imageURL, withImage: image)
             self.fetchingImages.removeAll { $0 == imageURL }
             completion(item, image)
         }
     }

     func loadImage(for item: PhotoData, completion: @escaping ImageCompletion) {
         let imageURL = item.urls.regular
         if let image = getImage(byImageURL: imageURL) {
             completion(item, image)
             return
         }

         fetchingImages.append(imageURL)
         completions[imageURL] = completion

         ImageService.shared.downloadImage(path: imageURL) { [weak self] data in
             guard let self = self else { return }
             guard let completion = self.completions[imageURL] else {
                 completion(item, nil)
                 return
             }

             let image = UIImage(data: data)
             self.storeImage(byImageURL: imageURL, withImage: image)

             completion(item, image)

             self.fetchingImages.removeAll { $0 == imageURL }
             self.completions.removeValue(forKey: imageURL)

         }
     }

     func cancelLoading(for item: ImageItemForCache) {
         let imageURL = item.urls.regular

         fetchingImages.removeAll  { $0 == imageURL }
         completions.removeValue(forKey: imageURL)
     }

    */
}



