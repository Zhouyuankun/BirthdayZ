//
//  EditBaseInfoSheet.swift
//  BirthdaZ
//
//  Focused sheet for editing basic information only
//

import SwiftUI
import SwiftData
import ZhDate
import PhotosUI

struct EditBaseInfoSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @Bindable var person: Person

    @State private var name: String
    @State private var gender: Gender
    @State private var themeColor: Color
    @State private var birthDate: Date
    @State private var birthdayCalendar: BirthdayCalendar

    // Photo state - edited values
    @State private var avatarData: Data?
    @State private var backgroundPhotoData: Data?

    // Original values for change detection
    @State private var originalAvatarData: Data?
    @State private var originalBackgroundData: Data?

    // Photo picker state
    @State private var selectedAvatarItem: PhotosPickerItem?
    @State private var selectedBackgroundItem: PhotosPickerItem?

    // Cancel alert state
    @State private var showCancelAlert = false

    init(person: Person) {
        self.person = person
        self._name = State(initialValue: person.name)
        self._gender = State(initialValue: person.gender)
        self._themeColor = State(initialValue: person.themeColor.color)
        self._birthDate = State(initialValue: person.birthDate)
        self._birthdayCalendar = State(initialValue: person.birthdayCalendar)
        _avatarData = State(initialValue: person.avatarData)
        _backgroundPhotoData = State(initialValue: person.backgroundPhotoData)
        _originalAvatarData = State(initialValue: person.avatarData)
        _originalBackgroundData = State(initialValue: person.backgroundPhotoData)
    }

    private var hasChanges: Bool {
        name != person.name ||
        gender != person.gender ||
        themeColor != person.themeColor.color ||
        birthDate != person.birthDate ||
        birthdayCalendar != person.birthdayCalendar ||
        avatarData != originalAvatarData ||
        backgroundPhotoData != originalBackgroundData
    }

    private func saveChanges() {
        person.name = name
        person.gender = gender
        person.themeColor = ColorComponents.fromColor(themeColor)
        person.birthDate = birthDate
        person.birthdayCalendar = birthdayCalendar
        person.avatarData = avatarData
        person.backgroundPhotoData = backgroundPhotoData
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

                Section("照片") {
                    // Avatar picker
                    HStack {
                        Text("头像")
                            .bold()
                        Spacer()
                        PhotosPicker(selection: $selectedAvatarItem, matching: .images) {
                            if let data = avatarData,
                               let image = imageFromData(data) {
                                image
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .clipShape(.circle)
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }

                    // Background photo picker
                    HStack {
                        Text("背景照片")
                            .bold()
                        Spacer()
                        PhotosPicker(selection: $selectedBackgroundItem, matching: .images) {
                            if let data = backgroundPhotoData,
                               let image = imageFromData(data) {
                                image
                                    .resizable()
                                    .frame(width: 60, height: 44)
                                    .clipShape(.rect(cornerRadius: 8))
                            } else {
                                Image(systemName: "photo.fill")
                                    .font(.title)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("编辑基本信息")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        if hasChanges {
                            showCancelAlert = true
                        } else {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveChanges()
                    }
                }
            }
        }
        .onChange(of: selectedAvatarItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let compressed = ImageCompressionHelper.compress(data, maxDimension: 800) {
                    avatarData = compressed
                }
            }
        }
        .onChange(of: selectedBackgroundItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let compressed = ImageCompressionHelper.compress(data, maxDimension: 800) {
                    backgroundPhotoData = compressed
                }
            }
        }
        .alert("确定要放弃更改吗？", isPresented: $showCancelAlert) {
            Button("放弃更改", role: .destructive) { dismiss() }
            Button("继续编辑", role: .cancel) { }
        }
    }
}