//
//  NetworkError.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/09.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCodeError(Int, String)
    case parsingError
    case networkUnavailable
    case dontknow
}

extension NetworkError {
    var toastMessage: String? {
        switch self {
        case .httpStatusCodeError(_, let error):
            return "\(error)"
        case .parsingError:
            return nil
        case .networkUnavailable:
            return "네트워크를 사용할 수 없습니다."
        case .dontknow:
            return nil
        }
    }
    var reason: String? {
        switch self {
        case .httpStatusCodeError(let code, let error):
            return "status code: \(code) ---------> \(error) 확인해주세요."
        case .parsingError:
            return "response 데이터 파싱 확인해주세요."
        case .networkUnavailable:
            return "네트워크를 사용할 수 없습니다."
        case .dontknow:
            return "☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️"
        }
    }
}

struct ErrorModel: Decodable {
    let errors: [String]
    
}
