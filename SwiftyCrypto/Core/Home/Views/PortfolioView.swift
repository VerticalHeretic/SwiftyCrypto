//
//  PortfolioView.swift
//  PortfolioView
//
//  Created by Łukasz Stachnik on 13/09/2021.
//

import SwiftUI

struct PortfolioView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var vm : HomeViewModel
    @State private var selectedCoin : Coin? = nil
    @State private var quantityText : String = ""
    @State private var showCheckmark : Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0, content: {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                    
                })
            }
            .background(
                Color.theme.background.ignoresSafeArea()
            )
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    })
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavbarButtons
                }
                
            })
            .onChange(of: vm.searchText) { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
        }
        
    }
}


struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(HomeViewModel())
    }
}

//MARK: View related extensions
extension PortfolioView {
    
    private var coinLogoList : some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                               updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear
                                        , lineWidth: 3)
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
    
    private func updateSelectedCoin(coin: Coin) {
        if selectedCoin?.id == coin.id {
            selectedCoin = nil
            quantityText = ""
        } else {
            selectedCoin = coin
            if let protfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
                let amount = protfolioCoin.currentHoldings {
                    quantityText = "\(amount)"
            } else {
                quantityText = ""
            }
            
        }
    }
    
    private var portfolioInputSection : some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "")")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith2Decimals() ?? "" )
            }
            Divider()
            HStack {
                Text("Amount in your portfolio:")
                Spacer()
                TextField("Ex. 1.4", text: $quantityText)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
                    .multilineTextAlignment(.trailing)
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    private var trailingNavbarButtons : some View {
       
            HStack(spacing: 10) {
                Image(systemName: "checkmark")
                    .foregroundColor(Color.theme.green)
                    .opacity(showCheckmark ? 1.0 : 0.0)
                
                Button {
                    saveButtonPressed()
                } label: {
                    Text("Save".uppercased())
                }
                .opacity(
                    (selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText.replacingOccurrences(of: ",", with: "."))) ? 1.0 : 0.0
                )
            }
            .font(.headline)
        
    }
    
}

//MARK: Logic releated extensions
extension PortfolioView {
    
    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText.replacingOccurrences(of: ",", with: ".")) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        
        return 0
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin,
              let amount = Double(quantityText.replacingOccurrences(of: ",", with: "."))
        else { return }
        
        // save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // show checkmark
        withAnimation(.easeIn) {
            showCheckmark = true
            removeSelectedCoin()
        }
        
        // hide keyboard
        UIApplication.shared.endEditing()
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut) {
                showCheckmark = false
            }
        }
        
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
}
