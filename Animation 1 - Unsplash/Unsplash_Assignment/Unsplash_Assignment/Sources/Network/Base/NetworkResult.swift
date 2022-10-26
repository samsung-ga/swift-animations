//
//  NetworkResult.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/13.
//

import Foundation

enum NetworkResult<Model: Decodable> {
    case success(Model)
    case failure(NetworkError)
}
