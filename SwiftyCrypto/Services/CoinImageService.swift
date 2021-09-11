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
    
    private let fileManager = LocalFileManager.instance
    private var imageSubscription : AnyCancellable?
    private let coin : Coin
    let folderName = "coin_images"
    private let imageName: String
    
    
    init(coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            print("[✅] Retrieved image from File Manager")
        } else {
            self.isLoading = true
            downloadCoinImage()
            print("[🛬] Downloading image now")
        }
    }
    
    private func downloadCoinImage() {
        guard let url = URL(string: coin.image ) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                
                guard let self = self, let downloadedImage = returnedImage else { return }
                
                self.isLoading = false
                self.image = returnedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
    
    
}
