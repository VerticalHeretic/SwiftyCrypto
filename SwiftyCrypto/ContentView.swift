//
//  ContentView.swift
//  SwiftyCrypto
//
//  Created by Łukasz Stachnik on 15/07/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background
            VStack(spacing: 20) {
                Text("Accent Color")
                    .foregroundColor(Color.theme.accent)
                Text("Secondary Text Color")
                    .foregroundColor(Color.theme.secondaryText)
                Text("Red Color")
                    .foregroundColor(Color.theme.red)
                Text("Green Color")
                    .foregroundColor(Color.theme.green)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
