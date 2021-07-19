//
//  HomeViewModel.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 19/07/2021.
//

import Foundation

class HomeViewModel : ObservableObject {
    
    @Published var allCoins : [Coin] = []
    @Published var portfolioCoins : [Coin] = []
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.allCoins.append(DeveloperPreview.instance.previewCoin)
            self.portfolioCoins.append(DeveloperPreview.instance.previewCoin)
        }
    }
}
