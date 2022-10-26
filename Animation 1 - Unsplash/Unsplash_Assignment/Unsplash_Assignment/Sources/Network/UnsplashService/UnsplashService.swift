//
//  UnsplashService.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/09.
//

import Foundation

struct UnsplashService {
   
    typealias PhotoReponse = [PhotoListResponse]
    typealias SearchResponse = SearchResultResponse
    
    private let networkManager: Networking

    init(networkManager: Networking = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func requestPhoto(byPage page: Int, completion: @escaping (PhotoReponse)->Void) {
        let request = PhotoListRequest(page: page)
        let api = UnsplashAPI.photos(request)
        networkManager.request(request: api.createURLRequest(),
                               requestModel: PhotoReponse.self) { result in
            switch result {
            case .success(let response):
                completion(response)
            case .failure:
                // TODO: 에러 처리
                break
            }
        }
    }
    
    func requestSearch(byKeyword keyword: String, page: Int, completion: @escaping (SearchResponse)->Void) {
        let request = SearchRequest(query: keyword, page: page)
        let api = UnsplashAPI.search(request)
        if page == 1 { LoadingIndicator.show() }
        networkManager.request(request: api.createURLRequest(),
                               requestModel: SearchResponse.self) { result in
            switch result {
            case .success(let response):
                LoadingIndicator.hide()
                completion(response)
            case .failure(let error):
                LoadingIndicator.hide()
                ToastView.show(text: "\(error.reason)")
                break
            }
        }
    }
}
