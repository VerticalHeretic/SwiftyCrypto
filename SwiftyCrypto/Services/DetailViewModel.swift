//
//  DetailViewModel.swift
//  DetailViewModel
//
//  Created by Lukasz Stachnik on 17/09/2021.
//

import Foundation
import Combine

final class DetailViewModel : ObservableObject {
    
    private let coinDetailService : CoinDetailDataService
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var coin : Coin
    @Published var isError : Bool = false
    @Published var error : Error? = nil
    @Published var overviewStatistics : [Statistic] = []
    @Published var additionalStatistics : [Statistic] = []
    @Published var coinDescription : String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    //MARK: Dependecies
    let networkingManager : DataProvider
    
    init(networkingManager: DataProvider ,coin: Coin) {
        self.networkingManager = networkingManager
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(networkingManager: networkingManager, coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {

        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (returnedArrays) in
                
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &subscriptions)
        
        coinDetailService.$coinDetails
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (returnedCoinDetails) in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &subscriptions)
    }
    
    /// Maps given coinDetail and coin Models to data needed for overviewa and additional information rows
    private func mapDataToStatistics(coinDetail : CoinDetail?, coinModel : Coin) -> (overview: [Statistic], additional: [Statistic]) {
        return (createOverviewArray(coinModel: coinModel), createAdditionalArray(coinModel: coinModel, coinDetail: coinDetail))
    }
    
    /**
     Creates array of Statistics specific for the Overview Information row in details view
     */
    private func createOverviewArray(coinModel : Coin) -> [Statistic] {
        //MARK: Overview Array
        
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = Statistic(title: "Current Price", value: price, percentageChange: pricePercentChange)
        
        let marketCap = "€" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = Statistic(title: "Market Capitalization", value: marketCap, percentageChange: marketCapChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = Statistic(title: "Rank", value: rank)
        
        let volume = "€" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let volumeStat = Statistic(title: "Volume", value: volume)
        
        let overviewArray : [Statistic] = [priceStat, marketCapStat,rankStat, volumeStat]
        
        return overviewArray
    }
    
    /**
     Creates array of Statistics specific for the Additional Information row in details view
     */
    private func createAdditionalArray(coinModel : Coin, coinDetail : CoinDetail?) -> [Statistic] {
        //MARK: Additional Array
        
        let high = coinModel.high24H?.asCurrencyWith2Decimals() ?? "n/a"
        let highStat = Statistic(title: "24h High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = Statistic(title: "24h Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let priceercentChangeAdditonal = coinModel.priceChangePercentage24H
        let priceChangeStat = Statistic(title: "24h Price Change", value: priceChange, percentageChange: priceercentChangeAdditonal)
        
        let marketCapChangeAdditional = "€" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChangeAdditional = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = Statistic(title: "24h Market Cap Change", value: marketCapChangeAdditional, percentageChange: marketCapPercentChangeAdditional)
        
        var blockTimeString = ""
        if let blockTime = coinDetail?.blockTimeInMinutes {
            blockTimeString = "\(blockTime) min"
        } else {
            blockTimeString = "n/a"
        }
        
        let blockStat = Statistic(title: "Block Time", value: blockTimeString)
        
        let hashing = coinDetail?.hashingAlgorithm ?? "n/a"
        let hashingStat = Statistic(title: "Hashing Algorithm", value: hashing)
        
        let additionalArray : [Statistic] = [highStat,lowStat,priceChangeStat,marketCapChangeStat,blockStat,hashingStat]
        return additionalArray
    }
}
