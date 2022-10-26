//
//  SearchWrapper.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/12.
//

import Foundation

struct SearchResultResponse: Decodable {
    let total: Int
    let totalPages: Int
    let results: [PhotoListResponse]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        
        total = (try? container?.decode(Int.self, forKey: .total)) ?? 0
        totalPages = (try? container?.decode(Int.self, forKey: .totalPages)) ?? 0
        results = (try? container?.decode([PhotoListResponse].self, forKey: .results)) ?? []
    }
}
