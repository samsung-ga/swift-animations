//
//  UnsplashPhoto.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/09.
//

import Foundation

struct PhotoListResponse: Decodable {
    
    let id: String
    let width, height: Int
    let urls: PhotoURL
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case urls
        case user
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        
        id = (try? container?.decode(String.self, forKey: .id)) ?? ""
        width = (try? container?.decode(Int.self, forKey: .width)) ?? 0
        height = (try? container?.decode(Int.self, forKey: .height)) ?? 0
        urls = (try? container?.decode(PhotoURL.self, forKey: .urls)) ?? PhotoURL.dummy
        user = (try? container?.decode(User.self, forKey: .user)) ?? User.dummy
    }
}

// MARK: PhotoURL
struct PhotoURL: Decodable {
    let thumb: String
    let regular: String
    
    enum CodingKeys: String, CodingKey {
        case thumb, regular
    }
    
    static let dummy = PhotoURL(thumb: "",
                                regular: "")
    
    static func ==(lhs: PhotoURL, rhs: PhotoURL) -> Bool {
        return (lhs.thumb == rhs.thumb &&
                lhs.regular == rhs.regular)
    }
}

// MARK: User
struct User: Decodable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    static let dummy = User(id: "",
                            name: "")
}

