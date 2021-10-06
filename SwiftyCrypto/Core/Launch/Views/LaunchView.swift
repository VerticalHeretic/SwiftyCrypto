//
//  LaunchView.swift
//  LaunchView
//
//  Created by Łukasz Stachnik on 23/09/2021.
//

import SwiftUI

struct LaunchView: View {

    @State private var loadingText: [String] = "Loading your portfolio...".map { String($0)}
    @State private var showLoadingText: Bool = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    @State private var counter: Int = 0
    @State private var loops: Int = 0
    @Binding var showLaunchView: Bool

    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()

            Image("logo-transparent")
                .resizable()
                .frame(width: 80, height: 80)

            ZStack {
                if showLoadingText {
                    HStack(spacing: 0) {
                        ForEach(loadingText.indices) { index in
                            Text(loadingText[index])
                                .font(.headline)
                                .fontWeight(.heavy)
                                .foregroundColor(Color.launch.accent)
                                .offset(y: counter == index ? -5 : 0)
                        }
                        .transition(AnyTransition.scale.animation(.easeIn))
                    }
                }
            }
            .offset(y: 70)
        }
        .onAppear {
            showLoadingText.toggle()
        }
        .onReceive(timer) { _ in
            withAnimation(.spring()) {

                if counter == loadingText.count - 1 {
                    counter = 0
                    loops += 1

                    if loops >= 2 {
                        showLaunchView = false
                    }

                } else {
                    counter += 1
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
