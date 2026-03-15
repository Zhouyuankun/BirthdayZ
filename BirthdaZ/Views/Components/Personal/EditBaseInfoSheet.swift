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

    // For editing existing person, this is set. For creating new, this is nil.
    private let existingPerson: Person?

    // The person being edited or created
    @State private var person: Person

    @State private var name: String
    @State private var gender: Gender
    @State private var themeColor: Color
    @State private var birthDate: Date
    @State private var birthdayCalendar: BirthdayCalendar

    // Photo state - edited values
    @State private var avatarData: Data?
    @State private var backgroundPhotoData: Data?

    // Original values for change detection (only used for existing person)
    @State private var originalAvatarData: Data?
    @State private var originalBackgroundData: Data?

    // Photo picker state
    @State private var selectedAvatarItem: PhotosPickerItem?
    @State private var selectedBackgroundItem: PhotosPickerItem?

    // Cancel alert state
    @State private var showCancelAlert = false

    private var isCreatingNew: Bool {
        existingPerson == nil
    }

    init(person: Person? = nil) {
        self.existingPerson = person
        if let person = person {
            // Editing existing person
            _person = State(initialValue: person)
            _name = State(initialValue: person.name)
            _gender = State(initialValue: person.gender)
            _themeColor = State(initialValue: person.themeColor.color)
            _birthDate = State(initialValue: person.birthDate)
            _birthdayCalendar = State(initialValue: person.birthdayCalendar)
            _avatarData = State(initialValue: person.avatarData)
            _backgroundPhotoData = State(initialValue: person.backgroundPhotoData)
            _originalAvatarData = State(initialValue: person.avatarData)
            _originalBackgroundData = State(initialValue: person.backgroundPhotoData)
        } else {
            // Creating new person with defaults
            let newPerson = Person(
                name: "",
                nickname: "",
                gender: .male,
                birthDate: .now,
                birthdayCalendar: .gregorian,
                themeColor: ColorComponents.fromColor(.blue)
            )
            _person = State(initialValue: newPerson)
            _name = State(initialValue: "")
            _gender = State(initialValue: .male)
            _themeColor = State(initialValue: .blue)
            _birthDate = State(initialValue: .now)
            _birthdayCalendar = State(initialValue: .gregorian)
            _avatarData = State(initialValue: nil)
            _backgroundPhotoData = State(initialValue: nil)
            _originalAvatarData = State(initialValue: nil)
            _originalBackgroundData = State(initialValue: nil)
        }
    }

    private var hasChanges: Bool {
        if isCreatingNew {
            // For new person, any non-default value is a change
            return !name.isEmpty ||
                   gender != .male ||
                   themeColor != .blue ||
                   birthDate != Date.now ||
                   birthdayCalendar != .gregorian ||
                   avatarData != nil ||
                   backgroundPhotoData != nil
        } else {
            // For existing person, compare to original
            guard let existingPerson = existingPerson else { return false }
            return name != existingPerson.name ||
                   gender != existingPerson.gender ||
                   themeColor != existingPerson.themeColor.color ||
                   birthDate != existingPerson.birthDate ||
                   birthdayCalendar != existingPerson.birthdayCalendar ||
                   avatarData != originalAvatarData ||
                   backgroundPhotoData != originalBackgroundData
        }
    }

    private func saveChanges() {
        person.name = name
        person.gender = gender
        person.themeColor = ColorComponents.fromColor(themeColor)
        person.birthDate = birthDate
        person.birthdayCalendar = birthdayCalendar
        person.avatarData = avatarData
        person.backgroundPhotoData = backgroundPhotoData

        if isCreatingNew {
            context.insert(person)
        }

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
            .navigationTitle(isCreatingNew ? "新建联系人" : "编辑基本信息")
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
        .alert(isCreatingNew ? "确定要取消创建吗？" : "确定要放弃更改吗？", isPresented: $showCancelAlert) {
            Button(isCreatingNew ? "取消创建" : "放弃更改", role: .destructive) { dismiss() }
            Button("继续编辑", role: .cancel) { }
        }
    }
}