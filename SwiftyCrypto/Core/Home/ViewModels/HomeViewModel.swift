//
//  HomeViewModel.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 19/07/2021.
//

import Foundation
import Combine

final class HomeViewModel : ObservableObject {
    
    @Published var statistics : [Statistic] = []
    @Published var allCoins : [Coin] = []
    @Published var portfolioCoins : [Coin] = []
    @Published var searchText : String = ""
    @Published var isLoading : Bool = false
    @Published var error : Error? = nil
    @Published var sortOption : SortOption = .holdings
    @Published var currentPortfolioValue : Double = 0.0 {
        didSet {
            UserDefaults.standard.set(currentPortfolioValue, forKey: "currentPortfolioValue")
        }
    }
    
    
    /// Main list of currencies service
    private let coinDataService : CoinDataService
    /// Top bar market data service
    private let marketDataService : MarketDataService
    /// PorfolioView service to save, get, update, remove from CoreData
    private let portfolioDataService = PortfolioDataService()
    /// Set of cancelables to store in the subscribers
    private var cancellables = Set<AnyCancellable>()
    
    /// Main list sorting options
    enum SortOption {
        case rank
        case rankReversed
        case holdings
        case holdingsReversed
        case price
        case priceReversed
    }
    
    //MARK: Dependecies
    
    let networkingManager : DataProvider
    
    init(networkingManager : DataProvider) {
        
        self.networkingManager = networkingManager
        self.coinDataService = CoinDataService(networkingManager: networkingManager)
        self.marketDataService = MarketDataService(networkingManager: networkingManager)
        
        // If we are unit testing we want to have some coins in
        if ProcessInfo.processInfo.environment["IS_UNIT_TESTING"] == "1" {
            allCoins = [Coin.testableCoin, Coin.testableCoin, Coin.testableCoin]
        } else {
            addSubscribers()
        }
   
    }
    
    /// Adds subscribers to the view model
    private func addSubscribers() {
        
        // Updates about data loading and error
        coinDataService.$isLoading
            .combineLatest(coinDataService.$error)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (loading, error) in
                self?.isLoading = loading
                self?.error = error
            }
            .store(in: &cancellables)

        // Updates allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // Updates porfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnedCoins) in
                guard let self = self else { return }
            
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        // Updates statistics
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .receive(on: DispatchQueue.main)
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
        self.isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(notificationType: .success)
    }
    
    /**
     Filter coins by the given text. It checks if any coin's name, symbol or id contains the given text. And then sorts it by given sort option.
     - Parameters:
        - text: Search text
        - coins: Arrays of coins to search in
        - sort : Sort option from **SortOption** enum
     - Returns: Array of filtered and sorted coins
     */
    func filterAndSortCoins(text: String, coins: [Coin], sort: SortOption) -> [Coin] {
        var filteredCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &filteredCoins)
        return filteredCoins
    }
    
    /// Sorts referenced array of coins by given **SortOption**
    private func sortCoins(sort: SortOption, coins: inout [Coin]) {
        switch sort {
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
             coins.sort(by: { $0.rank > $1.rank })
        case .price:
             coins.sort(by: { $0.currentPrice < $1.currentPrice})
        case .priceReversed:
             coins.sort(by: { $0.currentPrice > $1.currentPrice})
        }
    }
    
    /// Sorts  array of coins in portfolio if needed
    private func sortPortfolioCoinsIfNeeded(coins: [Coin]) -> [Coin]{
        switch sortOption {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue})
        default:
            return coins
        }
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
                
        self.currentPortfolioValue = portfolioCoins
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
        
        let percentageChange = ((currentPortfolioValue - previousValue) / previousValue)
        
        let portfolio = Statistic(title: "Portfolio Value", value: currentPortfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        
        return stats
    }
    
    
}
