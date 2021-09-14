//
//  MarketDataService.swift
//  MarketDataService
//
//  Created by Łukasz Stachnik on 13/09/2021.
//

import Foundation
import Combine

class MarketDataService {
    
    @Published var marketData: MarketData? = nil
    
    var marketSubscription : AnyCancellable?
    
    init() {
        getMarketData()
    }
    
    func getMarketData() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketSubscription?.cancel()
            })
           
    }
}
