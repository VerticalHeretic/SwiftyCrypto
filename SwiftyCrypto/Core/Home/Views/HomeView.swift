//
//  HomeView.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 17/07/2021.
//

import SwiftUI

struct HomeView: View {

    @State private var showPortfolio: Bool = false // anime right
    @State private var showPortfolioView: Bool = false // new sheet
    @State private var showSettingsView: Bool = false
    @State private var selectedCoin: Coin?
    @State private var showDetailView: Bool = false
    @State private var shouldReload: Bool = false

    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject var quickActions: QuickActionService

    var body: some View {
        ZStack {

            // background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(viewModel)
                }

            if let error = viewModel.error {
                ErrorView(error: error, reloadData: $shouldReload)
            } else {
                // content layer
                VStack {
                    homeHeader

                    HomeStatsView(showPortfolio: $showPortfolio)
                    SearchBarView(searchText: $viewModel.searchText)
                    columnTitles

                    if viewModel.isLoading {
                        ProgressView()
                            .offset(y: 250)
                    } else {
                        if !showPortfolio {
                            allCoinsList
                                .transition(.move(edge: .leading))
                        }

                        if showPortfolio {
                            ZStack(alignment: .top) {
                                if viewModel.portfolioCoins.isEmpty && viewModel.searchText.isEmpty {
                                    emptyText
                                } else {
                                    portfolioCoinsList
                                }
                            }
                            .transition(.move(edge: .trailing))
                        }

                    }
                    Spacer(minLength: 0)
                }
                .sheet(isPresented: $showSettingsView) {
                    AboutView()
                }
                .onChange(of: shouldReload, perform: { _ in
                    viewModel.reloadData()
                })

            }

        }
        .onChange(of: quickActions.action, perform: { action in
            handleQuickAction(action: action)
        })
        .background(
            NavigationLink(destination: DetailLoadingView(
                coin: $selectedCoin,
                networkingManager: viewModel.networkingManager),
                isActive: $showDetailView,
                label: { EmptyView() }))
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
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
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
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: true, networkingManager: viewModel.networkingManager)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .listStyle(PlainListStyle())

    }

    private var allCoinsList : some View {
        List {
            ForEach(viewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false, networkingManager: viewModel.networkingManager)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
                    .listRowBackground(Color.theme.background)
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
                    .opacity((viewModel.sortOption == .rank || viewModel.sortOption == .rankReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .rank ? 0 : 180))

            }
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((viewModel.sortOption == .holdings ||
                                  viewModel.sortOption == .holdingsReversed) ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: viewModel.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.default) {
                        viewModel.sortOption = viewModel.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((viewModel.sortOption == .price || viewModel.sortOption == .priceReversed) ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: viewModel.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                withAnimation(.default) {
                    viewModel.sortOption = viewModel.sortOption == .price ? .priceReversed : .price
                }
            }

            Button {
                withAnimation(.default, {
                    viewModel.reloadData()
                })
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: viewModel.isLoading ? 360 : 0), anchor: .center)

        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }

    private var emptyText : some View {
        Text("You haven't added any coins to your porfolio yet! Click the + button to get started. 🧐")
            .font(.callout)
            .foregroundColor(Color.theme.accent)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .padding(50)
    }

    private func handleQuickAction(action: QuickAction?) {
        switch action {
        case .protfolio:
            Info.log("showingProftolio")
            showPortfolio.toggle()
        case .about:
            Info.log("showingSettings")
            showSettingsView.toggle()
        case .none:
            break
        }
    }
}
