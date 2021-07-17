//
//  CoinModel.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 17/07/2021.
//

import Foundation

/*
 curl -X 'GET' \
   'https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=250&page=1&sparkline=true' \
   -H 'accept: application/json'
 */

// MARK: - Coin
struct Coin {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank: Double?
    let fullyDilutedValuation: Double?
    let totalVolume: Double?
    let high24H, low24H, priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply: Double?
    let totalSupply, maxSupply: Double?
    let ath, athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
}

// MARK: - Roi
struct Roi {
    let times: Double?
    let currency: Currency?
    let percentage: Double?
}

enum Currency {
    case btc
    case eth
    case usd
}

// MARK: - SparklineIn7D
struct SparklineIn7D {
    let price: [Double]?
}
