//
//  NetworkManager.swift
//  Unsplash_Assignment
//
//  Created by Woody on 2022/02/09.
//

import Foundation

protocol Networking {
    func request<Model: Decodable>(request: URLRequest,
                                   requestModel: Model.Type,
                                   completion: @escaping (NetworkResult<Model>) -> Void)
    func downloadImage(request: URLRequest,
                       requestModel: Data.Type,
                       completion: @escaping (NetworkResult<Data>)-> Void)
}

struct NetworkManager: Networking {
    
    private let session: URLSession = {
        return URLSession.shared
    }()
    
    func request<Model: Decodable>(request: URLRequest,
                                   requestModel: Model.Type,
                                   completion: @escaping (NetworkResult<Model>) -> Void) {
        
        // loggingRequest(request: request)
        
        let task = session.dataTask(with: request) { data, response, error in
            do {
                // loggingResponse(data, response: response, error: error)
                
                try httpStatusProcess(response, data)
                
                guard let data = data else { return }
                let decoder = JSONDecoder.init()
                guard let responseModel = try? decoder.decode(Model.self, from: data) else {
                    throw NetworkError.parsingError
                }
                
                return completion(NetworkResult.success(responseModel))
            } catch NetworkError.parsingError {
                return completion(NetworkResult.failure(.parsingError))
            } catch NetworkError.httpStatusCodeError(let code, let errors) {
                return completion(NetworkResult.failure(.httpStatusCodeError(code, errors)))
            } catch {
                return completion(NetworkResult.failure(.dontknow))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(request: URLRequest,
                       requestModel: Data.Type,
                       completion: @escaping (NetworkResult<Data>)-> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            do {
                try httpStatusProcess(response, data)

                guard let data = data else { return }
                return completion(NetworkResult.success(data))
            } catch NetworkError.parsingError {
                return completion(NetworkResult.failure(.parsingError))
            } catch NetworkError.httpStatusCodeError(let code, let errors) {
                return completion(NetworkResult.failure(.httpStatusCodeError(code, errors)))
            } catch {
                return completion(NetworkResult.failure(.dontknow))
            }
        }
        
        task.resume()
    }
    
    private func httpStatusProcess(_ response: URLResponse?,_ data: Data?) throws {
        if let response = response as? HTTPURLResponse, let data = data {
            if !(200...299).contains(response.statusCode)  {
                let errors: String = String(data: data, encoding: .utf8) ?? ""
                throw NetworkError.httpStatusCodeError(response.statusCode, errors)
            }
        }
    }
    
    private func loggingRequest(request: URLRequest) {
        print("👉👉👉👉👉 HTTP Request 👈👈👈👈👈")
        print("URL          : \(request.url?.absoluteString ?? "")")
        print("Header       : \(request.allHTTPHeaderFields ?? [:])")
        print("Body         : \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")
    }
    
    private func loggingResponse(_ data: Data?, response: URLResponse?, error: Error?) {
        
        if let error = error {
            print("☠️☠️☠️☠️☠️ HTTP Response ☠️☠️☠️☠️☠️")
            print("Error Message: \(error.localizedDescription)")
            print("URL       : \(response?.url?.absoluteString ?? "")")
        } else {
            guard let urlResponse = response else { return }
            print("🌈🌈🌈🌈🌈 HTTP Response 🌈🌈🌈🌈🌈")
            print("URL          : \(urlResponse.url?.absoluteString ?? "")")
            print("Body         : \(String(data: data ?? Data(), encoding: .utf8) ?? "")")
        }
    }
}
