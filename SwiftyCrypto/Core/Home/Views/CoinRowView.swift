//
//  CoinRowView.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 19/07/2021.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            Circle()
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
            Spacer()
            VStack(alignment: .trailing){
                Text("\(coin.currentPrice.asCurrencyWith6Decimals())")
                Text("\(coin.priceChangePercentage24H ?? 0)%")
                    .foregroundColor(
                        (coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            }
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.previewCoin)
    }
}
