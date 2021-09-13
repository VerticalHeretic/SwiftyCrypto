//
//  CoinLogoView.swift
//  CoinLogoView
//
//  Created by Łukasz Stachnik on 13/09/2021.
//

import SwiftUI

struct CoinLogoView: View {
    
    let coin: Coin
    
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinLogoView(coin: dev.previewCoin)
                .previewLayout(.sizeThatFits)
            CoinLogoView(coin: dev.previewCoin)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
        }
   
    }
}
