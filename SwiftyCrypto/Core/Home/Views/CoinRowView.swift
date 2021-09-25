//
//  CoinRowView.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 19/07/2021.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: Coin
    let showHoldingsColumn : Bool
    let networkingManager : DataProvider
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if showHoldingsColumn {
               centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
        .background(
            Color.theme.background.opacity(0.001) //it will make all view clickable
        )
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.previewCoin, showHoldingsColumn: true, networkingManager: dev.networkingManager)
            .previewLayout(.sizeThatFits)
        CoinRowView(coin: dev.previewCoin, showHoldingsColumn: true, networkingManager: dev.networkingManager)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}

extension CoinRowView {
    
    private var leftColumn : some View {
        HStack(spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(networkingManager: networkingManager, coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var centerColumn : some View {
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightColumn : some View {
        VStack(alignment: .trailing){
            Text("\(coin.currentPrice.asCurrencyWith6Decimals())")
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing) // we don't need to use GeometryReader while we only use portrait mode
        //TODO: Maybe add it in the future
    }
}
