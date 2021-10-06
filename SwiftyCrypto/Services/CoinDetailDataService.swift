//
//  CoinDetailDataService.swift
//  CoinDetailDataService
//
//  Created by Lukasz Stachnik on 17/09/2021.
//

import Foundation
import Combine

final class CoinDetailDataService {

    @Published var coinDetails: CoinDetail?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var serviceIsActive: Bool = true

    var subscriptions = Set<AnyCancellable>()
    let loadCoinDetails = CurrentValueSubject<String, Never>("")
    let coin: Coin

    // MARK: Depedencies
    let networkingManager: DataProvider

    init(networkingManager: DataProvider, coin: Coin) {
        self.coin = coin
        self.networkingManager = networkingManager

        getCoinDetails(coin: coin)
    }

    func getCoinDetails(coin: Coin) {
        let url = "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"

        loadCoinDetails
            .removeDuplicates()
            .compactMap { URL(string: $0) }
            .flatMap { (url) -> AnyPublisher<CoinDetail, Never> in
                self.networkingManager.fetch(url: url)
                    .decode(type: CoinDetail.self, decoder: JSONDecoder())
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
            } receiveValue: { [unowned self] (details) in
                self.coinDetails = details
            }
            .store(in: &subscriptions)

        loadCoinDetails.send(url)

    }
}
