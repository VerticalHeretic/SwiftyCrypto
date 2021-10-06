//
//  ChartView.swift
//  ChartView
//
//  Created by Łukasz Stachnik on 18/09/2021.
//

import SwiftUI

struct ChartView: View {

    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date

    @State private var percentage: CGFloat = 0

    init(coin: Coin) {
        self.data = coin.sparkline7d?.price ??  []
        self.maxY = data.max() ?? 0
        self.minY = data.min() ?? 0

        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red

        endingDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
    }

    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(chartYAxis, alignment: .leading)

            chartDateLabels
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.previewCoin)
    }
}

extension ChartView {

    private var chartView : some View {
        GeometryReader { geo in
            Path { path in
                for index in data.indices {

                    let xPosition = geo.size.width / CGFloat(data.count) * CGFloat(index + 1) // gives us standard increment

                    let yAxis = maxY - minY
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geo.size.height

                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(self.lineColor, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            .shadow(color: self.lineColor, radius: 5, x: 0, y: 10)
            .shadow(color: self.lineColor.opacity(0.5), radius: 5, x: 0, y: 20)
            .shadow(color: self.lineColor.opacity(0.2), radius: 5, x: 0, y: 30)
            .shadow(color: self.lineColor.opacity(0.1), radius: 5, x: 0, y: 40)
        }
    }

    private var chartBackground : some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }

    private var chartYAxis : some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }

    private var chartDateLabels : some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}
