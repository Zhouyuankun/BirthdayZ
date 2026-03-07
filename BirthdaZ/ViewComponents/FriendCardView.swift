//
//  FriendCardView.swift
//  BirthdaZ
//
//  Extracted from PeopleListView.swift
//

import SwiftUI

struct FriendCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    let item: Person

    var body: some View {
        let themeColor = item.themeColor.color
        HStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(themeColor.opacity(0.3))
                    .shadow(color: themeColor, radius: 5, x: -5, y: 0)
                VStack(spacing: 10) {
                    Text(item.name)
                        .font(.title3)
                    Text(item.nextBirthday.dateToString(stringFormat: "YYYY-MM-dd"))
                    if (item.birthdayCalendar == .nongli) {
                        HStack {
                            LeapMonthIconView()
                            Text("\(item.birthDateInChineseCalendar.monthdayNumString)")
                                .font(.subheadline)
                        }

                    }
                    Text("\(item.age)")
                        .font(.title)
                }
            }
            ZStack {
                Rectangle()
                    .fill(themeColor.opacity(0.1))
                    .shadow(color: themeColor, radius: 5, x: 5, y: 0)

                VStack {

                    if item.isBirthdayToday {

                        Text("Happy birthday !")
                            .font(.title)
                        Image(systemName: "gift")
                            .font(.title)

                    } else {
                        let daycnt = item.daysToNextBirthday
                        let progresscnt = Int(Double(366 - daycnt) / Double(366) * 100)
                        Text("Next birthday in \(daycnt) days")
                            .font(.caption)
                        AnimatedRingView(ring: Ring(progress: CGFloat(progresscnt), value: "Steps", keyIcon: "figure.walk", keyColor: themeColor))
                            .frame(width: 75)
                            .padding(10)
                    }
                }
                .padding()
                .cornerRadius(10)
            }
        }
        .cornerRadius(10)
        .padding(.horizontal)
    }
}