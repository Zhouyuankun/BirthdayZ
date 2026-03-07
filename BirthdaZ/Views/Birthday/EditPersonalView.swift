//
//  EditPersonalView.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2/23/25.
//

import SwiftUI
import OSLog

fileprivate let logger = Logger(subsystem: "BirthdaZ", category: "EditPersonalView")

struct EditPersonalView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    let editedModel: Person
    
    init(editedModel: Person) {
        self.editedModel = editedModel
        self.name = editedModel.name
        self.birthday = editedModel.birthDate
        self.gender = editedModel.gender
        self.themeColor = editedModel.themeColor.color
        self.birthdayCalendar = editedModel.birthdayCalendar
        self.sentGifts = editedModel.sentGifts
    }
    
    @State var name: String
    @State var birthday: Date
    @State var gender: Gender
    @State var themeColor: Color
    @State var birthdayCalendar: BirthdayCalendar
    @State var sentGifts: [GiftModel]
    
    func savePerson() {
        editedModel.name = name
        editedModel.birthDate = birthday
        editedModel.gender = gender
        editedModel.themeColor = ColorComponents.fromColor(themeColor)
        editedModel.birthdayCalendar = birthdayCalendar
        editedModel.sentGifts = sentGifts

        do {
            try context.save()
        } catch {
            logger.error("Failed to save person: \(error.localizedDescription)")
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("姓名")
                            .bold()
                        TextField("Input name here", text: $name)
                            .submitLabel(.done)
                            .padding(.all, 5)
                            .background(Color.adaptiveLabel.opacity(0.1))
                            .clipShape(.rect(cornerRadius: 5))
                    }
                    
                    HStack {
                        Text("性别")
                            .bold()
                        Picker("Gender", selection: $gender) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Text(gender.rawValue).tag(gender)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    HStack {
                        Text("主题颜色")
                            .bold()
                        ColorPicker("", selection: $themeColor)
                    }
                }
                
                Section {
                    HStack {
                        Text("出生日期")
                            .bold()
                        DatePicker("", selection: $birthday, displayedComponents: .date)
                    }
                    
                    HStack {
                        Text("生日历法")
                            .bold()
                        Picker("Birthday Calendar", selection: $birthdayCalendar) {
                            ForEach(BirthdayCalendar.allCases, id: \.self) { calendar in
                                Text(calendar.rawValue).tag(calendar)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    
                    HStack {
                        Text("生日文本")
                            .bold()
                        Text(birthdayCalendar == .nongli ? "农历 " +  birthday.nongDate.monthDayDescription() : "公历 " + birthday.monthdayCHString)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                
                Section(content: {
//                    HStack {
//                        Text("送礼时间")
//                            .frame(maxWidth: .infinity)
//                        Text("送礼类型")
//                            .frame(maxWidth: .infinity)
//                        Text("礼物描述")
//                            .frame(maxWidth: .infinity)
//                    }
                    List {
                        ForEach($sentGifts, id: \.id) { $gift in
                            NavigationLink(destination: {
                                EditSentGiftView(sentGift: $gift)
                            }, label: {
                                VStack(spacing: 0) {
                                    HStack {
                                        HStack {
                                            Image(systemName: "gift")
                                            Text(gift.giftType.rawValue)
                                        }
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                        .padding(5)
                                        .background(.blue)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                        Spacer()
                                        Text(gift.sentDate.dateToString(stringFormat: "yyyy-MM-dd")).font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(gift.giftDesc)
                                        .font(.caption)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            })
                        }
                        .onDelete { offsets in
                            sentGifts.remove(atOffsets: offsets)
                        }
                    }
                }, header: {
                    HStack {
                        Text("送礼历史")
                            .bold()
                        Spacer()
                        #if os(iOS)
                        EditButton()
                        #endif
                        Button(action: {
                            sentGifts.append(GiftModel(person: editedModel, sentDate: .now, giftType: .books, giftDesc: "123"))
                        }, label: {
                            Image(systemName: "plus.circle")
                        })
                    }
                })
                
            }
            .navigationTitle("Edit Info")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        savePerson()
                        dismiss()
                        
                    }
                }
            }
        }
    }
}

struct EditSentGiftView: View {
    @Binding var sentGift: GiftModel
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("礼物描述")
                        .bold()
                    TextField("Input gift description here", text: $sentGift.giftDesc)
                        .submitLabel(.done)
                        .padding(.all, 5)
                        .background(Color.adaptiveLabel.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 5))
                }
                HStack {
                    Text("送礼时间")
                        .bold()
                    DatePicker("", selection: $sentGift.sentDate, displayedComponents: .date)
                }
                HStack {
                    Text("礼物类型")
                        .bold()
                    Picker("", selection: $sentGift.giftType) {
                        ForEach(GiftType.allCases, id: \.self) { giftType in
                            Text(giftType.rawValue).tag(giftType)
                        }
                    }
                }
            }
            
        }
    }
}
