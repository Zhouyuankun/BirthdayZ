//
//  GiftSentView.swift
//  BirthdaZ
//
//  Extracted from PersonalView.swift
//

import SwiftUI

struct GiftSentView: View {
    let editedModel: Person

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("送礼历史")
                    .bold()
                Spacer()
            }
            Divider()

            ScrollView(.horizontal) {
                HStack {
                    ForEach(editedModel.sentGifts, id: \.self) { gift in
                        SingleGiftCard(gift: gift)
                    }
                }
            }
            .scrollIndicators(.hidden)



            GiftPieChartView(data: [
                .init(category: "Xcode", count: 79),
                .init(category: "Swift", count: 73),
                .init(category: "SwiftUI", count: 58),
                .init(category: "WWDC", count: 15),
                .init(category: "SwiftData", count: 9)
              ])


        }
    }
}