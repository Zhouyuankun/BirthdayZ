//
//  SingleGiftCard.swift
//  BirthdaZ
//
//  Extracted from PersonalView.swift
//

import SwiftUI

struct SingleGiftCard: View {
    let gift: GiftModel

    var body: some View {
        HStack(spacing: 5) {
            VStack {
                Image(systemName: "gift")
                Text(gift.giftType.rawValue)
            }
            .foregroundStyle(.white)
            .padding(.all, 10)
            .background(.blue)

            VStack(alignment: .leading) {
                Text(gift.giftDesc)

                Spacer()


                Text(gift.sentDate.dateToString(stringFormat: "yyyy-MM-dd")).font(.caption)
                    .foregroundStyle(.secondary)

            }
            .frame(width: 100, alignment: .leading)
        }
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .background(
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke()
                .fill(Color.adaptiveLabel)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        )
    }
}