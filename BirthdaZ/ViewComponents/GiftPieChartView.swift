//
//  GiftPieChartView.swift
//  BirthdaZ
//
//  Pie chart view for gift statistics with tap selection
//

import SwiftUI
import Charts

struct GiftPieChartView: View {
    let data: [GiftCount]

    @State private var selectedAngle: Double?

    private let categoryRanges: [(category: String, range: Range<Double>)]
    private let totalGifts: Int

    init(data: [GiftCount]) {
        self.data = data
        self.totalGifts = data.reduce(0) { $0 + $1.count }

        var total = 0.0
        var ranges: [(category: String, range: Range<Double>)] = []
        for item in data {
            let newTotal = total + Double(item.count)
            ranges.append((category: item.category, range: total..<newTotal))
            total = newTotal
        }
        self.categoryRanges = ranges
    }

    private var selectedCategory: String? {
        guard let selectedAngle else { return nil }
        for (category, range) in categoryRanges {
            if range.contains(selectedAngle) {
                return category
            }
        }
        return nil
    }

    private func colorForCategory(_ category: String) -> Color {
        guard let giftType = GiftType(rawValue: category) else { return .gray }
        return giftType.color
    }

    private func symbolForCategory(_ category: String) -> String {
        guard let giftType = GiftType(rawValue: category) else { return "gift" }
        return giftType.symbol
    }

    private func opacityForCategory(_ category: String) -> Double {
        guard let selected = selectedCategory else { return 1.0 }
        return category == selected ? 1.0 : 0.4
    }

    var titleView: some View {
        VStack(spacing: 4) {
            if let category = selectedCategory {
                Image(systemName: symbolForCategory(category))
                    .font(.title2)
                Text(category)
                    .font(.headline)
                if let count = data.first(where: { $0.category == category })?.count {
                    Text("\(count) gifts")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                Text("Categories")
                    .font(.headline)
                Text("\(totalGifts) gifts")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    var body: some View {
        Chart(data, id: \.category) { item in
            SectorMark(
                angle: .value("Count", item.count),
                innerRadius: .ratio(0.618),
                angularInset: 1.5
            )
            .cornerRadius(4)
            .foregroundStyle(colorForCategory(item.category))
            .opacity(opacityForCategory(item.category))
        }
        .scaledToFit()
        .chartLegend(alignment: .center, spacing: 12)
        .chartAngleSelection(value: $selectedAngle)
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                if let anchor = chartProxy.plotFrame {
                    let frame = geometry[anchor]
                    titleView
                        .position(x: frame.midX, y: frame.midY)
                }
            }
        }
        .padding()
    }
}