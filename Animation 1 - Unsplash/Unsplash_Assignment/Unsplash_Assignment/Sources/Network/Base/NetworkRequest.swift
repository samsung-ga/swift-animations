//
//  NetworkRequest.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/09.
//

import Foundation

struct RequestMethod {
    static let get = RequestMethod(value: "GET")
    static let post = RequestMethod(value: "POST")
    static let put = RequestMethod(value: "PUT")
    static let delete = RequestMethod(value: "DELETE")
    
    let value: String
    init(value: String) {
        self.value = value
    }
}

protocol RequestProtocol {
    var headers: [String: String]? { get }
    var path: String { get }
    var params: [String: String]? { get }
    var requestMethod: RequestMethod { get }
}

extension RequestProtocol {
    var headers: [String : String]? {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ACCESS_KEY") as? String,
              !apiKey.isEmpty else { return nil }
        return [
            "Authorization": "Client-ID 580z-rpEKkYTMzLGL_IJj0m4ec2-lXIyM_iVvF2D3GI" // \(apiKey)
        ]
    }
}

extension RequestProtocol {
    private func createURComponentsL() -> URLComponents {
        var urlComponents = URLComponents(string: ServerHost.baseURL)!
        urlComponents.path = path
        guard let params = params else { return urlComponents }
        urlComponents.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return urlComponents
    }
    
    private func addHeaders(_ urlRequest: URLRequest) -> URLRequest {
        var urlRequest = urlRequest
        headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        return urlRequest
    }
    
    /// URLRequest를 반환해줍니다.
    func createURLRequest() -> URLRequest {
        guard let url = createURComponentsL().url else {
            fatalError(Converting.ParsingError.stringToURLError.localizedDescription)
        }
        let request = addHeaders(URLRequest(url: url))
        
        return request
    }
}
