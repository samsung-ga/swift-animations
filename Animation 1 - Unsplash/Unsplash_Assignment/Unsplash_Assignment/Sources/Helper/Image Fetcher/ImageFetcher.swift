//
//  ImageFetcher.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/11.
//

import UIKit

class ImageFetcher {
    
    private let loadingQueue = OperationQueue()
    private var loadingOperations: [IndexPath: ImageFetcherOperation] = [:]
    
    init() {
        loadingQueue.maxConcurrentOperationCount = 1
    }
    
    /// 비동기로 cell 데이터(image 렌더링) 준비 (queue 확인)
    func fetchAsync(indexPath: IndexPath, data: PhotoData, completion: @escaping ((PhotoData, Bool) -> Void))  {
        if let operation = loadingOperations[indexPath] {
            if let image = operation.fetchedData.image {
                data.image = image
                loadingOperations.removeValue(forKey: indexPath)
                completion(data, false)
            } else {
                
                let removeLoadingOperationClosure: ()->Void = { [weak self] in
                    guard let self = self else { return }
                    self.loadingOperations.removeValue(forKey: indexPath)
                }
                operation.operationCompleteHanlder = removeLoadingOperationClosure
                operation.loadingCompleteHandler = completion
            }
        } else {
            if let _ = data.image {
                completion(data, false)
            } else {
                let operation = ImageFetcherOperation(fetchedData: data)
                
                let removeLoadingOperationClosure: ()->Void = { [weak self] in
                    guard let self = self else { return }
                    self.loadingOperations.removeValue(forKey: indexPath)
                }
                operation.operationCompleteHanlder = removeLoadingOperationClosure
                operation.loadingCompleteHandler = completion
                
                loadingQueue.addOperation(operation)
                loadingOperations[indexPath] = operation
            }
            
        }
    }
    
    func cancelFetch(indexPath: IndexPath) {
        if let operation = loadingOperations[indexPath] {
            operation.cancel()
            loadingOperations.removeValue(forKey: indexPath)
        }
    }
    
    /// loadingQueue 에 operation 삽입
    func prefetchData(indexPath: IndexPath, data: PhotoData)  {
        if let _ = loadingOperations[indexPath] {
            return
        }
        let operation = ImageFetcherOperation(fetchedData: data)
        loadingQueue.addOperation(operation)
        loadingOperations[indexPath] = operation
    }
}
