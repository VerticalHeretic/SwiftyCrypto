//
//  DetailViewModel.swift
//  DetailViewModel
//
//  Created by Lukasz Stachnik on 17/09/2021.
//

import Foundation
import Combine

class DetailViewModel : ObservableObject {
    
    private let coinDetailService : CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .sink { [weak self] (returnedCoinDetails) in
                
                print("RECEIVED COIN DETAILS DATA")
                print(returnedCoinDetails)
            }
            .store(in: &cancellables)
    }
}
