//
//  GiftSentView.swift
//  BirthdaZ
//
//  Gift history view with dashboard and list layout
//

import SwiftUI

struct GiftSentView: View {
    let editedModel: Person
    var editAction: (() -> Void)? = nil

    @State private var sortOption: SortOption = .dateDescending
    @State private var filterCategory: GiftType? = nil

    enum SortOption: String, CaseIterable {
        case dateDescending = "Recent"
        case dateAscending = "Oldest"
    }

    private var statistics: GiftStatistics {
        GiftStatistics(from: editedModel.sentGifts)
    }

    private var filteredGifts: [GiftModel] {
        var gifts = editedModel.sentGifts

        // Filter
        if let category = filterCategory {
            gifts = gifts.filter { $0.giftType == category }
        }

        // Sort
        switch sortOption {
        case .dateDescending:
            return gifts.sorted { $0.sentDate > $1.sentDate }
        case .dateAscending:
            return gifts.sorted { $0.sentDate < $1.sentDate }
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("送礼历史")
                    .bold()
                Spacer()
                Text("\(editedModel.sentGifts.count) 件")
                    .foregroundStyle(.secondary)
                if let action = editAction {
                    CardEditButton(action: action)
                }
            }

            // Statistics Dashboard
            if !editedModel.sentGifts.isEmpty {
                HStack(spacing: 20) {
                    StatItem(value: "\(statistics.totalCount)", label: "Total")
                    StatItem(value: "\(statistics.thisYearCount)", label: "This Year")
                    StatItem(value: statistics.topCategory, label: "Top Category")
                }
            }

            // Pie Chart (with real data)
            if !statistics.categoryData.isEmpty {
                GiftPieChartView(data: statistics.categoryData)
                    .frame(height: 200)
            }

            // Controls
            if editedModel.sentGifts.count > 1 {
                HStack {
                    Picker("Sort", selection: $sortOption) {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.menu)

                    Spacer()

                    Menu {
                        Button("All") { filterCategory = nil }
                        ForEach(GiftType.allCases, id: \.self) { type in
                            Button(type.rawValue) { filterCategory = type }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease")
                            Text(filterCategory?.rawValue ?? "All")
                        }
                    }
                }
            }

            Divider()

            // Gift List
            ForEach(filteredGifts, id: \.self) { gift in
                GiftListItem(gift: gift)
            }

            if filteredGifts.isEmpty {
                Text("No gifts")
                    .foregroundStyle(.secondary)
                    .padding()
            }
        }
    }
}

struct StatItem: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .bold()
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}