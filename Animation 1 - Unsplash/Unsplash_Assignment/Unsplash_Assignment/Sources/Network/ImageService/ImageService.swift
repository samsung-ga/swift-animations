//
//  ImageService.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/10.
//

import Foundation

struct ImageService {
    static let shared = ImageService()
    typealias ImageData = Data
    private let networkManager: Networking
    
    init(networkManager: Networking = NetworkManager()) {
        self.networkManager = networkManager
    }
    func downloadImage(path: String, completion: @escaping (ImageData)->Void) {
        networkManager.downloadImage(request: createImageURLRequest(path),
                                     requestModel: ImageData.self) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure:
                // TODO: 에러 처리
                break
            }
        }
    }
    
    private func createImageURLRequest(_ path: String) -> URLRequest {
        guard let url = URL(string: path) else {
            fatalError(Converting.ParsingError.stringToURLError.localizedDescription)
        }
        return URLRequest(url: url)
    }
}
