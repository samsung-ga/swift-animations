//
//  ImageFetcherOperation.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/10.
//

import UIKit

/// Image 렌더링해주는 operation
class ImageFetcherOperation: Operation {
    
    var fetchedData: PhotoData
    var loadingCompleteHandler: ((PhotoData, Bool) -> Void)?
    var operationCompleteHanlder: (()->Void)?
    
    init(fetchedData: PhotoData) {
        self.fetchedData = fetchedData
    }
    
    override func main() {
        if isCancelled {
            operationCompleteHanlder?()
            return
        }
        
        let imageURL: String = fetchedData.urls.regular
        
        if let image = ImageCacheManager.shared.getImage(byImageURL: imageURL) {
            self.fetchedData.image = image
            
            if let loadingCompleteHandler = self.loadingCompleteHandler {
                DispatchQueue.main.async {
                    loadingCompleteHandler(self.fetchedData, true)
                }
            }
        } else {
            ImageService.shared.downloadImage(path: imageURL) { [weak self] in
                guard let self = self else { return }
                
                if self.isCancelled {
                    self.operationCompleteHanlder?()
                    return
                }
                
                let image = UIImage(data: $0)
                
                self.fetchedData.image = image
                
                if self.isCancelled {
                    self.operationCompleteHanlder?()
                    return
                }
                
                if let loadingCompleteHandler = self.loadingCompleteHandler {
                    ImageCacheManager.shared.storeImage(byImageURL: imageURL, withImage: image)
                    DispatchQueue.main.async {
                        loadingCompleteHandler(self.fetchedData, true)
                    }
                }
            }
        }
    }
}
