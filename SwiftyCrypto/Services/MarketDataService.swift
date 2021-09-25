//
//  MarketDataService.swift
//  MarketDataService
//
//  Created by Łukasz Stachnik on 13/09/2021.
//

import Foundation
import Combine

final class MarketDataService {
    
    @Published var marketData: MarketData? = nil
    @Published var isLoading : Bool = false
    @Published var error : Error? = nil
    @Published var serviceIsActive : Bool = true
    
    var subscriptions = Set<AnyCancellable>()
    let loadMarketData = CurrentValueSubject<String, Never>("")
    private let url : String = "https://api.coingecko.com/api/v3/global"
    //MARK: Dependecies
    let networkingManager : DataProvider
    
    init(networkingManager : DataProvider) {
        self.networkingManager = networkingManager
        getMarketData()
    }
    
    func getMarketData() {
        
        loadMarketData
            .removeDuplicates()
            .compactMap({ URL(string: $0)})
            .flatMap { (url) -> AnyPublisher<GlobalData, Never> in
                self.networkingManager.fetch(url: url)
                    .decode(type: GlobalData.self, decoder: JSONDecoder())
                    .handleEvents(receiveCompletion: { (completion) in
                        switch completion {
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.error = error
                                Info.error(error.localizedDescription)
                            }
                        case .finished:
                            self.isLoading = false
                        }
                    }, receiveRequest: { _ in
                        self.isLoading = true
                    })
                    .catch { _ in
                        Empty()
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.serviceIsActive = false
            } receiveValue: { [unowned self] (globalData) in
                self.marketData = globalData.data
            }
            .store(in: &subscriptions)
        
        loadMarketData.send(url)
    }

}
