//
//  DetailView.swift
//  DetailView
//
//  Created by Łukasz Stachnik on 17/09/2021.
//

import SwiftUI

struct DetailLoadingView : View {
    @Binding var coin : Coin?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(coin: coin)
            }
        }
     
    }
    
}

struct DetailView: View {
    
    var coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
    }
    
    var body: some View {
        Text(coin.name)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.previewCoin)
    }
}
