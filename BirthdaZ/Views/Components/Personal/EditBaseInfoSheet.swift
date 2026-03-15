//
//  EditBaseInfoSheet.swift
//  BirthdaZ
//
//  Focused sheet for editing basic information only
//

import SwiftUI
import SwiftData
import ZhDate

struct EditBaseInfoSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @Bindable var person: Person

    @State private var name: String
    @State private var gender: Gender
    @State private var themeColor: Color
    @State private var birthDate: Date
    @State private var birthdayCalendar: BirthdayCalendar

    init(person: Person) {
        self.person = person
        self._name = State(initialValue: person.name)
        self._gender = State(initialValue: person.gender)
        self._themeColor = State(initialValue: person.themeColor.color)
        self._birthDate = State(initialValue: person.birthDate)
        self._birthdayCalendar = State(initialValue: person.birthdayCalendar)
    }

    private func saveChanges() {
        person.name = name
        person.gender = gender
        person.themeColor = ColorComponents.fromColor(themeColor)
        person.birthDate = birthDate
        person.birthdayCalendar = birthdayCalendar
        dismiss()
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("基本信息") {
                    HStack {
                        Text("姓名")
                            .bold()
                        TextField("输入姓名", text: $name)
                            .submitLabel(.done)
                            .padding(.all, 5)
                            .background(Color.adaptiveLabel.opacity(0.1))
                            .clipShape(.rect(cornerRadius: 5))
                    }

                    HStack {
                        Text("性别")
                            .bold()
                        Spacer()
                        Picker("性别", selection: $gender) {
                            ForEach(Gender.allCases, id: \.self) { Text($0.rawValue) }
                        }
                        .pickerStyle(.segmented)
                    }

                    HStack {
                        Text("主题颜色")
                            .bold()
                        Spacer()
                        ColorPicker("", selection: $themeColor)
                    }
                }

                Section("生日信息") {
                    HStack {
                        Text("出生日期")
                            .bold()
                        Spacer()
                        DatePicker("", selection: $birthDate, displayedComponents: .date)
                    }

                    HStack {
                        Text("生日历法")
                            .bold()
                        Spacer()
                        Picker("生日历法", selection: $birthdayCalendar) {
                            ForEach(BirthdayCalendar.allCases, id: \.self) { Text($0.rawValue) }
                        }
                        .pickerStyle(.segmented)
                    }

                    HStack {
                        Text("生日文本")
                            .bold()
                        Spacer()
                        Text(birthdayCalendar == .nongli ? "农历 " + birthDate.nongDate.monthDayDescription() : "公历 " + birthDate.monthdayCHString)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("编辑基本信息")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveChanges()
                    }
                }
            }
        }
    }
}