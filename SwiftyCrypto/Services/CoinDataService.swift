//
//  CoinDataService.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 20/07/2021.
//

import Foundation
import Combine

class CoinDataService  {
    @Published var allCoins: [Coin] = []
    @Published var isLoading : Bool = false
    @Published var error : Error? = nil
    @Published var serviceIsActive : Bool = true
    
    var subscriptions = Set<AnyCancellable>()
    let loadCoins = CurrentValueSubject<String, Never>("")
    let url =  "https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=250&page=1&sparkline=true"
    
    //MARK: Dependecies
    let networkingManager : DataProvider
    
    init(networkingManager : DataProvider = NetworkingManager()) {
        self.networkingManager = networkingManager
        getCoins()
    }
    
    func getCoins() {
        loadCoins
            .removeDuplicates()
            .compactMap {
                URL(string: $0)
            }
            .print("🅰️")
            .flatMap { (url) -> AnyPublisher<[Coin], Never> in
                self.networkingManager.fetch(url: url)
                    .decode(type: [Coin].self, decoder: JSONDecoder())
                    .handleEvents(receiveCompletion: { (completion) in
                        switch completion {
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.error = error
                            }
                        case .finished:
                            print("✅ Finished loading")
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
            } receiveValue: { [unowned self] (coins) in
                print(coins.map({ $0.name }))
                self.allCoins = coins
            }
            .store(in: &subscriptions)
        
        loadCoins.send(url)
    }
    
    
}
