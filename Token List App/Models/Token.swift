//
//  Token.swift
//  Token List App
//
//  Created by Artem Poluyanovich on 18/12/2024.
//

import Foundation

// MARK: - TokensResponse
struct TokensResponse: Decodable {
    let tokens: [Token]
}

// MARK: - Token
struct Token: Decodable {
    let liquidity: Double
    let extensions: Extensions?
    let logoURI: String
    let symbol: String
    let mc: Double
    let v24hUSD: Double
    let decimals: Int
    let price: Double
    let address: String
    let v24hChangePercent: Double
    let lastTradeUnixTime: Int
    let name: String
}

// MARK: - Extensions
struct Extensions: Decodable {
    let description: String?
}
