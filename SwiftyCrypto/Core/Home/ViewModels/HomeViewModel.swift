//
//  HomeViewModel.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 19/07/2021.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    
    @Published var allCoins : [Coin] = []
    @Published var portfolioCoins : [Coin] = []
    
    @Published var searchText : String = ""
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    /// Adds subscribers to the view model
    func addSubscribers() {
        // Updates allCoins
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
            
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
    
    
}
