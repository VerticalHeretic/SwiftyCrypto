//
//  CoinDetailDataService.swift
//  CoinDetailDataService
//
//  Created by Lukasz Stachnik on 17/09/2021.
//

import Foundation
import Combine

class CoinDetailDataService : ErrorPublishedProtocol {
    
    let coin : Coin
    
    @Published var coinDetails : CoinDetail? = nil
    @Published var isLoading : Bool = false
    @Published private(set) var isError : Bool = false
    @Published private(set) var error : Error? = nil
    
    
    var errorPublisher: Published<Error?> { _error }
    var isErrorPublisher: Published<Bool> { _isError }
    
    var coinDetailSubscription : AnyCancellable?

    //MARK: Depedencies
    let networkingManager : DataProvider
    
    init(networkingManager : DataProvider, coin : Coin) {
        self.coin = coin
        self.networkingManager = networkingManager
        
        getCoinDetails(coin: coin)
    }
    
    func getCoinDetails(coin : Coin) {
        self.isLoading = true
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailSubscription = networkingManager.fetch(url: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self?.showError(error: error)
                }
            }, receiveValue: { [weak self] (returnedCoinDetails) in
                self?.isLoading = false
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscription?.cancel()
            })
        
    }
    
    func showError(error: Error) {
        self.isError = true
        self.error = error
    }
}
