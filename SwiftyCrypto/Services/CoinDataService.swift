//
//  CoinDataService.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 20/07/2021.
//

import Foundation
import Combine

class CoinDataService {
    
    @Published var allCoins: [Coin] = []
    @Published var isLoading : Bool = false
    @Published var isError : Bool = false
    
    var coinSubscription : AnyCancellable?
    
    init() {
        self.isLoading = true
        getCoins()
    }
    
    private func getCoins() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=250&page=1&sparkline=true") else { return }
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isError = true
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] (returnedCoins) in
                self?.isLoading = false
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
        
    }
}
