//
//  BirthdayCountView.swift
//  BirthdaZ
//
//  Extracted from PersonalView.swift
//

import SwiftUI

struct BirthdayCountView: View {
    let editedModel: Person

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("生日倒计时")
                    .bold()
                Spacer()
            }
            Divider()

            HStack {
                Spacer()
                Text("距\(editedModel.nextBirthday.dateToString(stringFormat: "yyyy年MM月dd日"))")
                    .font(.caption)
                    .foregroundStyle(.secondary)

            }


            HStack {
                if editedModel.isBirthdayToday {
                    Text("Happy birthday !")
                        .font(.title)
                    Spacer()
                    Image(systemName: "gift")
                        .font(.title)
                } else {
                    let daycnt = editedModel.daysToNextBirthday
                    let progresscnt = Int(Double(366 - daycnt) / Double(366) * 100)
                    AnimatedRingView(ring: Ring(progress: CGFloat(progresscnt), value: "Steps", keyIcon: "figure.walk", keyColor: editedModel.themeColor.color))
                        .frame(width: 100)
                    Spacer()
                    HStack {
                        Text("\(daycnt)")
                            .font(.title)
                        Text("days")
                    }
                }
            }
            .padding()
            .cornerRadius(10)
        }
    }
}