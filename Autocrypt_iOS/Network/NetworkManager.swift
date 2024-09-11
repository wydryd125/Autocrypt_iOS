//
//  NetworkManager.swift
//  Autocrypt_iOS
//
//  Created by wjdyukyung on 9/10/24.
//

import Foundation
import RxSwift

enum API {}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

final class NetworkManager {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    enum Encoding {
        case json
        case url
    }
    
    func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response> {
        let encoding: Encoding
        switch endpoint.method {
        case .post, .put, .patch:
            encoding = .json
        default:
            encoding = .url
        }
        
        guard var urlComponents = URLComponents(string: endpoint.path.stringValue) else {
            return .error(NetworkError.network)
        }
        
        if let parameters = endpoint.parameters, encoding == .url {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = urlComponents.url else {
            return .error(NetworkError.network)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        if let headers = endpoint.headers {
            request.allHTTPHeaderFields = headers
        }
        
        if let parameters = endpoint.parameters, encoding == .json {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        return session.fetchData(request: request)
            .map { data in
                do {
                    return try endpoint.decode(data)
                } catch {
                    throw NetworkError.decoding
                }
            }
            .catch { error in
                let networkError: NetworkError
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        networkError = .network
                    default:
                        networkError = .network
                    }
                } else {
                    networkError = .network
                }
                return .error(networkError)
            }
    }
}

enum NetworkError: Error {
    case network
    case decoding
}

extension URLSession {
    func fetchData(request: URLRequest) -> Single<Data> {
        return Single.create { single in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                } else if let data = data {
                    single(.success(data))
                } else {
                    single(.failure(NetworkError.network))
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
