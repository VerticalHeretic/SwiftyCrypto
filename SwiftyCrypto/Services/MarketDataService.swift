//
//  MarketDataService.swift
//  MarketDataService
//
//  Created by Łukasz Stachnik on 13/09/2021.
//

import Foundation
import Combine

class MarketDataService : ErrorPublishedProtocol {
    
    @Published var marketData: MarketData? = nil
    @Published private(set) var isError : Bool = false
    @Published private(set) var error : Error? = nil
    
    
    var errorPublisher: Published<Error?> { _error }
    var isErrorPublisher: Published<Bool> { _isError }
    
    var marketSubscription : AnyCancellable?
    
    init() {
        getMarketData()
    }
    
    func getMarketData() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self?.showError(error: error)
                }
            }, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketSubscription?.cancel()
            })
    }
    
    func showError(error: Error) {
        self.isError = true
        self.error = error
    }
}
