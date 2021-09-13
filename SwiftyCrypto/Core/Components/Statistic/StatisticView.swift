//
//  StatisticView.swift
//  StatisticView
//
//  Created by Lukasz Stachnik on 11/09/2021.
//

import SwiftUI

struct StatisticView: View {
    
    let stat : Statistic
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (stat.percentageChange ?? 0) >= 0 ?
                                    0 : 180))
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                .bold()
            }
            .foregroundColor((stat.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatisticView(stat: dev.stat1)
            StatisticView(stat: dev.stat2)
            StatisticView(stat: dev.stat3)
        }
        
    }
}
