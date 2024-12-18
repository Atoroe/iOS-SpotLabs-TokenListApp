//
//  RestService.swift
//  Token List App
//
//  Created by Artem Poluyanovich on 18/12/2024.
//

import Foundation

protocol RestServiceProtocol {
    func send<ResultType: Decodable>(_ request: ApiRequestProtocol, decodedType: ResultType.Type) async throws -> ResultType
}

final class RestService: RestServiceProtocol {
    
    private func buildURLRequest(_ request: ApiRequestProtocol) async throws -> URLRequest {
        guard let urlComponent = NSURLComponents(string: request.baseURL + request.path) else {
            throw RestServiceError.invalidAPIRequest
        }
        if let queryDictionary = request.queryParameters {
            urlComponent.queryItems = queryDictionary.map {
                URLQueryItem(name: $0, value: $1 as? String)
            }
        }
        guard let url = urlComponent.url else {
            throw RestServiceError.invalidAPIRequest
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        request.headers.forEach() {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        if let parameters = request.parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            } catch {
                throw error
            }
        }
        return urlRequest
    }
    
    @discardableResult
    private func sendDataRequest(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw RestServiceError.APIError(data)
        }
        return data
    }
    
    func send<ResultType: Decodable>(_ request: ApiRequestProtocol, decodedType: ResultType.Type) async throws -> ResultType where ResultType : Decodable {
        let urlRequest = try await buildURLRequest(request)
        let data = try await sendDataRequest(urlRequest)
        let decodedData = try JSONDecoder().decode(decodedType.self, from: data)
        return decodedData
    }
}

extension RestService {
    enum RestServiceError: Error {
        case invalidAPIRequest
        case APIError(Data?)
        case emptyResponse
        case unknown
    }
}

extension RestService.RestServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidAPIRequest:
            return "Invalid API request. Please check the parameters or URL."
        case .APIError(let data):
            if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                return "API error: \(errorMessage)"
            }
            return "API error. No additional information is available."
        case .emptyResponse:
            return "The server response is empty. Please check your connection or try again later."
        case .unknown:
            return "An unknown error occurred. Please try again."
        }
    }
}
