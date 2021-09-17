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
    
    @StateObject var vm : DetailViewModel
    
    init(coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        Text("Hello")
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.previewCoin)
    }
}
