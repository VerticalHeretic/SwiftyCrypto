//
//  CoinImageService.swift
//  CoinImageServic
//
//  Created by Łukasz Stachnik on 09/09/2021.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image : UIImage? = nil
    @Published var isLoading : Bool = false
    @Published var error : Error? = nil
    @Published var serviceIsActive : Bool = true
    
    private let fileManager = LocalFileManager.instance
    private var subscriptions = Set<AnyCancellable>()
    private let coin : Coin
    let folderName = "coin_images"
    private let imageName: String
    let loadImage = CurrentValueSubject<String, Never>("")
    
    //MARK: Depedencies
    let networkingManager : DataProvider
    
    
    init(networkingManager : DataProvider, coin: Coin) {
        self.networkingManager = networkingManager
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
        } else {
            self.isLoading = true
            downloadCoinImage()
        }
    }
    
    private func downloadCoinImage() {
        loadImage
            .removeDuplicates() // if the path is the same it will be removed
            .compactMap{ URL(string: $0)}
            .flatMap { (url) -> AnyPublisher<UIImage, Never> in
                self.networkingManager.fetch(url: url)
                    .compactMap {
                        UIImage(data: $0)
                    }
                    .handleEvents(receiveCompletion: { (completion) in
                        switch completion {
                        case .failure(let error):
                            DispatchQueue.main.async {
                                self.error = error
                                Info.error(error.errorDescription ?? "")
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
                    .retry(2)
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                self.serviceIsActive = false
            } receiveValue: { [unowned self] (image) in
                self.image = image
            }
            .store(in: &subscriptions)
        
        loadImage.send(coin.image)
    }
    
}
