//
//  PhotoData.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/12.
//

import UIKit

class PhotoData: Hashable {
    let id: String
    let name: String
    let width, height: Int
    let urls: PhotoURL
    var image: UIImage?
    var thumbImage: UIImage?
    let uuid: UUID
    
    init(id: String, name: String, width: Int, height: Int, urls: PhotoURL) {
        self.id = id
        self.name = name
        self.width = width
        self.height = height
        self.urls = urls
        self.uuid = UUID()
    }
}

extension PhotoData {
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(uuid)
    }
    static func == (lhs: PhotoData, rhs: PhotoData) -> Bool {
        return (lhs.id == rhs.id &&
                lhs.uuid == rhs.uuid)
    }
}
