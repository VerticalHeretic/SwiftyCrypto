//
//  CoinDetailDataService.swift
//  CoinDetailDataService
//
//  Created by Lukasz Stachnik on 17/09/2021.
//

import Foundation
import Combine

class CoinDetailDataService {
    
    let coin : Coin
    
    @Published var coinDetails : CoinDetail? = nil
    @Published var isLoading : Bool = false
    @Published var isError : Bool = false
    
    var coinDetailSubscription : AnyCancellable?
    
    init(coin : Coin) {
        self.coin = coin
        getCoinDetails(coin: coin)
    }
    
    func getCoinDetails(coin : Coin) {
        self.isLoading = true
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailSubscription = NetworkingManager.download(url: url)
            .decode(type: CoinDetail.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion
            , receiveValue: { [weak self] (returnedCoinDetails) in
                self?.isLoading = false
                self?.coinDetails = returnedCoinDetails
                self?.coinDetailSubscription?.cancel()
            })
        
    }
}
