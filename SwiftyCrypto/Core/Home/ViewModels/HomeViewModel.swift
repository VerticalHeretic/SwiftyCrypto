//
//  HomeViewModel.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 19/07/2021.
//

import Foundation
import Combine


class HomeViewModel : ObservableObject {
    
    @Published var statistics : [Statistic] = []
    @Published var allCoins : [Coin] = []
    @Published var portfolioCoins : [Coin] = []
    @Published var searchText : String = ""
    @Published var coinsLoading : Bool = false
    @Published var showError : Bool = false
    
    /// Main list of currencies service
    private let coinDataService = CoinDataService()
    /// Top bar market data service
    private let marketDataService = MarketDataService()
    /// PorfolioView service to save, get, update, remove from CoreData
    private let portfolioDataService = PortfolioDataService()
    /// Set of cancelables to store in the subscribers
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        // If we are unit testing we want to have some coins in
        if ProcessInfo.processInfo.environment["IS_UNIT_TESTING"] == "1" {
            allCoins = [Coin.testableCoin, Coin.testableCoin, Coin.testableCoin]
        } else {
            addSubscribers()
        }
   
    }
    
    /// Adds subscribers to the view model
    func addSubscribers() {
        
        //Updates about data loading
        coinDataService.$isLoading
            .sink { [weak self] (returnedLoading) in
                self?.coinsLoading = returnedLoading
            }
            .store(in: &cancellables)

        // Updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // Updates porfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // Updates statistics
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
                
       
    }
    
    /// Updates porfolio data in CoreData storage
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    /// Reloads data in API handling services
    func reloadData() {
        self.coinsLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(notificationType: .success)
    }
    
    /**
     Filter coins by the given text. It checks if any coin's name, symbol or id contains the given text.
     - Parameters:
        - text: Search text
        - coins: Arrays of coins to search in
     - Returns: Array of filtered coins
     */
    func filterCoins(text: String, coins: [Coin]) -> [Coin]{
        guard !text.isEmpty else {
            return coins
        }
        
        let lowercasedText = text.lowercased()
        
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowercasedText) || coin.symbol.lowercased().contains(lowercasedText) || coin.id.contains(lowercasedText)
        }
    }
    
    /**
        Maps allCoins and portfolioCoins to return current porfolio coins of the user with prices etc.
        - Parameters:
            - allCoins : All coins (probably filtered) from the viewmodel
            - portfolioEntities: Entities of porfolio, taken from users CoreData storage
        - Returns: Array of coins in users portfolio
     
     */
    private func mapAllCoinsToPortfolioCoins(allCoins: [Coin], portfolioEntities: [PortfolioEntity]) -> [Coin] {
        
        allCoins
            .compactMap { coin -> Coin? in
                guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id
                }) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    /**
        Maps globalMarketData to wanted parts of top bar in application
        - Parameters:
            - marketDataModel: Data we get from CoinGeko from global endpoint
            - portfolioCoins : Coins user has in his portfolio
        - Returns: Array of wanted statistics
     */
    func mapGlobalMarketData(marketDataModel : MarketData?, portfolioCoins : [Coin]) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data = marketDataModel else {
            return stats
        }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24h Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
                
        let portfolioValue = portfolioCoins
            .map({ $0.currentHoldingsValue })
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = coin.priceChangePercentage24H ?? 0 / 100 // 25% -> 25 that is how the data is coming from the API
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        let portfolio = Statistic(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        
        return stats
    }
    
    
}
