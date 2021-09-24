//
//  CoinDataService.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 20/07/2021.
//

import Foundation
import Combine

class CoinDataService : ErrorPublishedProtocol {


    @Published var allCoins: [Coin] = []
    @Published var isLoading : Bool = false
    @Published private(set) var isError : Bool = false
    @Published private(set) var error : Error? = nil
    
    
    var errorPublisher: Published<Error?> { _error }
    var isErrorPublisher: Published<Bool> { _isError }
    
    var coinSubscription : AnyCancellable?
    let loadCoins = CurrentValueSubject<String, Never>("")
    
    //MARK: Dependecies
    let networkingManager : DataProvider
    
    
    init(networkingManager : DataProvider) {
        self.networkingManager = networkingManager
        getCoins()
    }
    
    func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=250&page=1&sparkline=true") else { return }
        
        coinSubscription = networkingManager.fetch(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self?.showError(error: error)
                }
            }
            , receiveValue: { [weak self] (returnedCoins) in
                self?.isLoading = false
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
        
    }
    
    func showError(error: Error) {
        self.isError = true
        self.error = error
    }
    
}
