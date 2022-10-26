//
//  SearchRequest.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/12.
//

import Foundation

struct SearchRequest: Encodable {
    let query: String
    let page: Int
    var perPage: Int = 30
     var orientation: Orientation = .portrait
}

enum Orientation: String, Encodable {
    case landscape
    case portrait
    case squarish
}
