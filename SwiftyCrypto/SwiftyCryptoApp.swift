//
//  SwiftyCryptoApp.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 15/07/2021.
//

import SwiftUI

@main
struct SwiftyCryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
