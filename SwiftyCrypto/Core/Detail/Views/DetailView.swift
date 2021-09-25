//
//  DetailView.swift
//  DetailView
//
//  Created by Łukasz Stachnik on 17/09/2021.
//

import SwiftUI

struct DetailLoadingView : View {
    @Binding var coin : Coin?
    let networkingManager : DataProvider
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailView(networkingManager: networkingManager, coin: coin)
            }
        }
    }
}

struct DetailView: View {
    
    @StateObject private var vm : DetailViewModel
    
    @State private var showFullDescription : Bool = false
    @State private var shouldReload : Bool = false
    
    private let columns : [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    private let spacing: CGFloat = 30
    
    init(networkingManager: DataProvider ,coin: Coin) {
        _vm = StateObject(wrappedValue: DetailViewModel(networkingManager: networkingManager, coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let error = vm.error {
                ErrorView(error: error, reloadData: $shouldReload)
            } else if vm.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack {
                        ChartView(coin: vm.coin)
                            .padding(.vertical)
                        VStack(spacing: 20) {
                            
                            overviewTitle
                            Divider()
                            
                            descriptionSection
                            
                            overviewGrid
                            
                            additionalTitle
                            Divider()
                            additionalGrid
                            
                            websiteSection
                            
                        }
                        .padding()
                    }
                    
                }
                .background(
                    Color.theme.background.ignoresSafeArea()
                )
                .navigationTitle(vm.coin.name)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        navigationBarTrailingItem
                    }
                }
                .onChange(of: shouldReload) { newValue in
                    vm.reloadData()
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(networkingManager: dev.networkingManager, coin: dev.previewCoin)
        }
    }
}

extension DetailView {
    private var overviewTitle : some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalTitle : some View {
        Text("Additional details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    private var overviewGrid : some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.overviewStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }
    }
    
    private var additionalGrid : some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: spacing,
            pinnedViews: []) {
                ForEach(vm.additionalStatistics) { stat in
                    StatisticView(stat: stat)
                }
            }

    }
    
    private var navigationBarTrailingItem : some View {
        HStack {
        Text(vm.coin.symbol.uppercased())
            .font(.headline)
            .foregroundColor(Color.theme.secondaryText)
            CoinImageView(networkingManager: vm.networkingManager, coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var descriptionSection : some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading) {
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    Button {
                        withAnimation(.easeInOut) {
                            HapticManager.notification(notificationType: .success)
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more..")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .accentColor(Color.theme.accent)

                }
                .frame(maxWidth: .infinity, alignment: .leading)
             
            }
        }

    }
    
    private var websiteSection : some View {
        HStack(spacing: 20) {
            if let website = vm.websiteURL,
               let url = URL(string: website) {
                HStack {
                    Link("Website", destination: url)
                    Image(systemName: "network")
                        .foregroundColor(.blue)
                }
            }
            
            if let redditString = vm.redditURL, let url = URL(string: redditString) {
                HStack(spacing: 15) {
                    Link("Reddit", destination: url)
                    Image("reddit")
                        .resizable()
                        .scaledToFit()
                        .background(
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 25, height: 25, alignment: .center)
                            
                        )
                        .frame(width: 15, height: 15)
                }
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
        
    }
}
