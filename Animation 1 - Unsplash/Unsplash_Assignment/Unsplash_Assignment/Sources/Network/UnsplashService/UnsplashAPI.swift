//
//  UnsplashAPI.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/09.
//

import Foundation

enum UnsplashAPI {
    case photos(PhotoListRequest)
    case search(SearchRequest)
}

extension UnsplashAPI: RequestProtocol {
   
    var path: String {
        switch self {
        case .photos:
            return "/photos"
        case .search:
            return "/search/photos"
        }
    }
    
    var requestMethod: RequestMethod {
        switch self {
        case .photos:
            return .get
        case .search:
            return .get
        }
    }
    
    var params: [String : String]? {
        switch self {
        case .photos(let request):
            return request.dictionary
        case .search(let request):
            return request.dictionary
        }
    }
}
