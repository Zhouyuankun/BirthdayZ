//
//  GiftStatistics.swift
//  BirthdaZ
//
//  Helper for computing gift statistics
//

import Foundation

struct GiftCount: Equatable {
    let category: String
    let count: Int
}

struct GiftStatistics {
    let totalCount: Int
    let thisYearCount: Int
    let topCategory: String
    let topCategoryCount: Int
    let categoryData: [GiftCount]

    init(from gifts: [GiftModel]) {
        self.totalCount = gifts.count

        let currentYear = Calendar.current.component(.year, from: .now)
        self.thisYearCount = gifts.filter {
            Calendar.current.component(.year, from: $0.sentDate) == currentYear
        }.count

        // Count by category
        var counts: [String: Int] = [:]
        for gift in gifts {
            let key = gift.giftType.rawValue
            counts[key, default: 0] += 1
        }

        // Find top category
        if let (top, topCount) = counts.max(by: { $0.value < $1.value }) {
            self.topCategory = top
            self.topCategoryCount = topCount
        } else {
            self.topCategory = "-"
            self.topCategoryCount = 0
        }

        // Convert to array for chart
        self.categoryData = counts.map { GiftCount(category: $0.key, count: $0.value) }
            .sorted { $0.count > $1.count }
    }
}