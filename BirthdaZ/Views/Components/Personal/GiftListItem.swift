//
//  GiftListItem.swift
//  BirthdaZ
//
//  List item component for vertical gift display
//

import SwiftUI

struct GiftListItem: View {
    let gift: GiftModel

    var body: some View {
        HStack(spacing: 12) {
            // Icon + Type
            VStack(spacing: 4) {
                Image(systemName: gift.giftType.symbol)
                    .font(.title2)
                Text(gift.giftType.rawValue)
                    .font(.caption2)
            }
            .foregroundStyle(.white)
            .frame(width: 60, height: 50)
            .background(gift.giftType.color)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            // Description + Date
            VStack(alignment: .leading, spacing: 4) {
                Text(gift.giftDesc)
                    .lineLimit(2)
                Text(gift.sentDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}