//
//  Converting.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/10.
//

import Foundation

enum Converting {
    enum ParsingError: LocalizedError {
        case stringToURLError
        case urlToDataError
        case dataToUIImageError
        case dictionaryToJson
    }
}
