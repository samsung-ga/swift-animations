//
//  Encodable+.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/12.
//

import Foundation

extension Encodable {
    
    /// 통신에 편리하도록 dictionary 형태로 변환해준다. 
    var dictionary: [String: String] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        guard let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return [:]
        }
        let converted = result.compactMapValues { "\($0)" }
        return converted
    }
}
