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
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        dataService.$allCoins.sink { [weak self] (returnedCoins) in
            self?.allCoins = returnedCoins
        }
        .store(in: &cancellables)
    }
    
    
}
