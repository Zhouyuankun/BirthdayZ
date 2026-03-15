//
//  ManageGiftsSheet.swift
//  BirthdaZ
//
//  Full gift management - add, edit, delete gifts
//

import SwiftUI
import SwiftData

// MARK: - Editable Gift Struct

/// Local struct for editing (not persisted) - used to avoid direct SwiftData model mutation
struct EditableGift: Identifiable {
    let id: String
    var sentDate: Date
    var giftType: GiftType
    var giftDesc: String

    init(from gift: GiftModel) {
        self.id = gift.id
        self.sentDate = gift.sentDate
        self.giftType = gift.giftType
        self.giftDesc = gift.giftDesc
    }

    init() {
        self.id = UUID().uuidString
        self.sentDate = .now
        self.giftType = .others
        self.giftDesc = ""
    }
}

// MARK: - Manage Gifts Sheet

struct ManageGiftsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    let person: Person

    // Local editable copies
    @State private var editedGifts: [EditableGift] = []
    @State private var showCancelAlert = false

    var body: some View {
        NavigationStack {
            List {
                ForEach($editedGifts) { $gift in
                    NavigationLink(destination: EditGiftView(editableGift: $gift)) {
                        GiftListItem(from: gift)
                    }
                }
                .onDelete { offsets in
                    editedGifts.remove(atOffsets: offsets)
                }
            }
            .navigationTitle("管理礼物")
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
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        let newGift = EditableGift()
                        editedGifts.append(newGift)
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear {
            editedGifts = person.sentGifts.map { EditableGift(from: $0) }
        }
        .alert("确定要放弃更改吗？", isPresented: $showCancelAlert) {
            Button("放弃更改", role: .destructive) { dismiss() }
            Button("继续编辑", role: .cancel) { }
        }
    }

    private var originalGifts: [EditableGift] {
        person.sentGifts.map { EditableGift(from: $0) }
    }

    private var hasChanges: Bool {
        if editedGifts.count != originalGifts.count { return true }
        for (edited, original) in zip(editedGifts, originalGifts) {
            if edited.sentDate != original.sentDate ||
               edited.giftType != original.giftType ||
               edited.giftDesc != original.giftDesc {
                return true
            }
        }
        return false
    }

    private func saveChanges() {
        // Remove all existing gifts
        for gift in person.sentGifts {
            context.delete(gift)
        }

        // Create new gifts from edited data
        for editableGift in editedGifts {
            let gift = GiftModel(
                person: person,
                sentDate: editableGift.sentDate,
                giftType: editableGift.giftType,
                giftDesc: editableGift.giftDesc
            )
            person.sentGifts.append(gift)
        }

        dismiss()
    }
}

// MARK: - Edit Gift View

struct EditGiftView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var editableGift: EditableGift

    @State private var giftDesc: String
    @State private var sentDate: Date
    @State private var giftType: GiftType
    @State private var showCancelAlert = false

    init(editableGift: Binding<EditableGift>) {
        self._editableGift = editableGift
        _giftDesc = State(initialValue: editableGift.wrappedValue.giftDesc)
        _sentDate = State(initialValue: editableGift.wrappedValue.sentDate)
        _giftType = State(initialValue: editableGift.wrappedValue.giftType)
    }

    private var hasChanges: Bool {
        giftDesc != editableGift.giftDesc ||
        sentDate != editableGift.sentDate ||
        giftType != editableGift.giftType
    }

    private func saveChanges() {
        editableGift.giftDesc = giftDesc
        editableGift.sentDate = sentDate
        editableGift.giftType = giftType
        dismiss()
    }

    var body: some View {
        Form {
            Section {
                HStack {
                    Text("礼物描述")
                        .bold()
                    TextField("输入礼物描述", text: $giftDesc)
                        .submitLabel(.done)
                        .padding(.all, 5)
                        .background(Color.adaptiveLabel.opacity(0.1))
                        .clipShape(.rect(cornerRadius: 5))
                }
                HStack {
                    Text("送礼时间")
                        .bold()
                    Spacer()
                    DatePicker("", selection: $sentDate, displayedComponents: .date)
                }
                HStack {
                    Text("礼物类型")
                        .bold()
                    Spacer()
                    Picker("", selection: $giftType) {
                        ForEach(GiftType.allCases, id: \.self) { giftType in
                            Text(giftType.rawValue).tag(giftType)
                        }
                    }
                }
            }
        }
        .navigationTitle("编辑礼物")
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
        .alert("确定要放弃更改吗？", isPresented: $showCancelAlert) {
            Button("放弃更改", role: .destructive) { dismiss() }
            Button("继续编辑", role: .cancel) { }
        }
    }
}