//
//  ErrorView.swift
//  ErrorView
//
//  Created by Łukasz Stachnik on 25/09/2021.
//

import SwiftUI

struct ErrorView: View {
    
    let error : Error
    @Binding var reloadData : Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 15){
            Image(systemName: "xmark.octagon.fill")
                .resizable()
                .font(.largeTitle)
                .foregroundColor(Color.theme.red)
                .frame(width: 100, height: 100)
            
            VStack(spacing: 0) {
                Text("Unfortunately error occured: ")
                    .font(.headline)
                Text(error.localizedDescription)
                    .font(.callout)
            }
            
            VStack {
                Button {
                    reloadData = true
                } label: {
                    HStack {
                        Image(systemName: "repeat")
                            .foregroundColor(.white)
                        Text("Tap to reload")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color.theme.accent)
                    )
                }
               
            }
        }
        .multilineTextAlignment(.center)

    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: NetworkingManager.NetworkingError.badResponse(statusCode: 400), reloadData: .constant(false))
            .preferredColorScheme(.dark)
        ErrorView(error: NetworkingManager.NetworkingError.badResponse(statusCode: 400), reloadData: .constant(false))
            
    }
}
