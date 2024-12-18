//
//  TokensService.swift
//  Token List App
//
//  Created by Artem Poluyanovich on 18/12/2024.
//

import Foundation

// MARK: - TokensUseCase
protocol TokensUseCase {
    func loadTokens() async throws -> [Token]
}

// MARK: - TokensService
final class TokensService: TokensUseCase {
    
    // MARK: Private properties
    private let networkService: RestService
    
    // MARK: Init
    init(networkService: RestService) {
        self.networkService = networkService
    }
    
    // MARK: Actions
    func loadTokens() async throws -> [Token] {
        let request = ApiRequest(
            baseURL: Constants.baseUrl,
            path: Constants.tokensPath,
            queryParameters: nil,
            method: .GET,
            parameters: nil,
            headers: Constants.headers
        )
        
        do {
            let result = try await networkService.send(request, decodedType: TokensResponse.self)
            return result.tokens
        } catch {
            throw error
        }
    }
}

// MARK: API Request Constants
private extension TokensService {
    enum Constants {
        static let baseUrl = "https://spot-labs.github.io/ios-interview-api/"
        static let tokensPath = "data.json"
        static let headers = ["Content-Type" : "application/x-www-form-urlencoded"]
    }
}
