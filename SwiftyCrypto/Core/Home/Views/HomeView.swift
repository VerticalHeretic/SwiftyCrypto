//
//  HomeView.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 17/07/2021.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio : Bool = false // anime right
    @State private var showPortfolioView : Bool = false // new sheet
    @EnvironmentObject private var vm : HomeViewModel
    
    @State private var selectedCoin : Coin? = nil
    @State private var showDetailView : Bool = false
    
    var body: some View {
        ZStack {
            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
                        
                // content layer
                VStack {
                    homeHeader
                    
                    HomeStatsView(showPortfolio: $showPortfolio)
                    SearchBarView(searchText: $vm.searchText)
                    
                    columnTitles
                    
                    if vm.coinsLoading {
                        ProgressView()
                            .padding(.top, 200)
                    } else if vm.showError {
                        VStack(alignment: .center, spacing: 15){
                            Image(systemName: "xmark.octagon.fill")
                                .font(.largeTitle)
                                .foregroundColor(Color.theme.red)
                            
                            Text("Unfortunately error happen when getting data.")
                                .multilineTextAlignment(.center)
                            
                            Button {
                                vm.addSubscribers()
                            } label: {
                                Image(systemName: "repeat")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(Color.theme.red)
                                    )
                            }

                          
                            
                        }
                        .frame(width: 150)
                        .padding(.top, 100)
                    } else {
                        
                        if !showPortfolio {
                                allCoinsList
                                    .transition(.move(edge: .leading))
                        }
                        
                        if showPortfolio {
                            portfolioCoinsList
                                .transition(.move(edge: .trailing))
                        }
                   
                }
                    Spacer(minLength: 0)
            }
            
        }
        .background(
            NavigationLink(destination: DetailLoadingView(coin: $selectedCoin),isActive: $showDetailView, label: { EmptyView() }))
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(dev.homeVM)
    }
}

extension HomeView {
    
    private var homeHeader : some View {
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
                .background(
                CircleButtonAnimationView(animate: $showPortfolio
                ))
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
    }
    
    private var portfolioCoinsList : some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                       segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
        
    }
    
    private var allCoinsList : some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                       segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func segue(coin: Coin) {
        selectedCoin = coin
        showDetailView.toggle()
    }
    
    private var columnTitles : some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
                
            }
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            
            Button {
                withAnimation(.default, {
                    vm.reloadData()
                })
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: vm.coinsLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
