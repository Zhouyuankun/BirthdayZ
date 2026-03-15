//
//  ManageGiftsSheet.swift
//  BirthdaZ
//
//  Full gift management - add, edit, delete gifts
//

import SwiftUI
import SwiftData

struct ManageGiftsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var person: Person

    var body: some View {
        NavigationStack {
            List {
                ForEach(person.sentGifts, id: \.id) { gift in
                    NavigationLink(destination: EditGiftView(gift: gift)) {
                        GiftListItem(gift: gift)
                    }
                }
                .onDelete { offsets in
                    person.sentGifts.remove(atOffsets: offsets)
                }
            }
            .navigationTitle("管理礼物")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("完成") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        let gift = GiftModel(person: person, sentDate: .now, giftType: .others, giftDesc: "")
                        person.sentGifts.append(gift)
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

struct EditGiftView: View {
    @Bindable var gift: GiftModel

    var body: some View {
        Form {
            Section {
                HStack {
                    Text("礼物描述")
                        .bold()
                    TextField("输入礼物描述", text: $gift.giftDesc)
                        .submitLabel(.done)
                        .padding(.all, 5)
                        .background(Color.adaptiveLabel.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 5))
                }
                HStack {
                    Text("送礼时间")
                        .bold()
                    Spacer()
                    DatePicker("", selection: $gift.sentDate, displayedComponents: .date)
                }
                HStack {
                    Text("礼物类型")
                        .bold()
                    Spacer()
                    Picker("", selection: $gift.giftType) {
                        ForEach(GiftType.allCases, id: \.self) { giftType in
                            Text(giftType.rawValue).tag(giftType)
                        }
                    }
                }
            }
        }
    }
}