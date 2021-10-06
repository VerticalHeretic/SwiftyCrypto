//
//  CoinImageView.swift
//  CoinImageView
//
//  Created by Łukasz Stachnik on 09/09/2021.
//

import SwiftUI

struct CoinImageView: View {

    @StateObject var vm: CoinImageViewModel

    init(networkingManager: DataProvider, coin: Coin) {
        _vm = StateObject(wrappedValue: CoinImageViewModel(networkingManager: networkingManager, coin: coin))
    }

    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(networkingManager: dev.networkingManager, coin: dev.previewCoin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
