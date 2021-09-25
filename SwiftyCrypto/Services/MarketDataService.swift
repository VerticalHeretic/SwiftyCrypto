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
    
    //MARK: Dependecies
    let networkingManager : DataProvider
    
    init(networkingManager : DataProvider) {
        self.networkingManager = networkingManager
        getMarketData()
    }
    
    func getMarketData() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketSubscription = networkingManager.fetch(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                   break
                }
            }, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketSubscription?.cancel()
            })
    }

}
