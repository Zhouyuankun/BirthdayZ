//
//  BaseInfoView.swift
//  BirthdaZ
//
//  Extracted from PersonalView.swift
//

import SwiftUI

struct BaseInfoView: View {
    let editedModel: Person

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("基础信息")
                    .bold()
                Spacer()
            }
            Divider()

            HStack {
                Text(editedModel.name)
                    .font(.largeTitle)
                Spacer()
                Text("\(editedModel.age)")
                    .font(.largeTitle)
            }

            HStack {
                Image("avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50)
                    .clipShape(.circle)

                Spacer()
                VStack(alignment: .trailing) {
                    Text(editedModel.birthdayCalendar == .nongli ? "农历 " + editedModel.birthDateInChineseCalendar.monthDayDescription() : "公历 " + editedModel.birthDate.monthdayCHString)
                    Text("出生于\(editedModel.birthDate.dateToString(stringFormat: "yyyy年MM月dd日"))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}