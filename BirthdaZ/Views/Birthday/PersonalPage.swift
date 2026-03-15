//
//  PersonalPage.swift
//  BirthdaZ
//
//  Extracted from PersonalView.swift
//

import SwiftUI
import OSLog

fileprivate let logger = Logger(subsystem: "BirthdaZ", category: "PersonalPage")

struct PersonalPage: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    let editedModel: Person

    @State private var showDeletionAlert: Bool = false
    @State private var showEditBaseInfo: Bool = false
    @State private var showManageGifts: Bool = false

    var body: some View {
        VStack(spacing: 15) {
            if let data = editedModel.backgroundPhotoData,
               let image = imageFromData(data) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .clipped()
            } else {
                Image("avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .clipped()
            }

            BaseInfoView(editedModel: editedModel) {
                showEditBaseInfo = true
            }
            .personalCardStyle()

            BirthdayCountView(editedModel: editedModel)
                .personalCardStyle()

            GiftSentView(editedModel: editedModel) {
                showManageGifts = true
            }
            .personalCardStyle()

            WishListView(model: editedModel)
                .personalCardStyle()

            BirthdayMomentView(model: editedModel)
                .personalCardStyle()

            Button(role: .destructive) {
                showDeletionAlert = true
            } label: {
                Label("删除", systemImage: "trash")
            }
            .foregroundStyle(.red)
            .buttonStyle(.personalButton)
            .padding(.bottom)

            Spacer()
        }
        .alert("Do you want to delete this person ?", isPresented: $showDeletionAlert) {
            Button("Confirm", role: .destructive) {
                dismiss()
                context.delete(editedModel)
                do {
                    try context.save()
                } catch {
                    logger.error("Failed to save context after delete: \(error.localizedDescription)")
                }
                showDeletionAlert = false
            }
            Button("Cancel", role: .cancel) {
                showDeletionAlert = false
            }
        }
        .sheet(isPresented: $showEditBaseInfo) {
            EditBaseInfoSheet(person: editedModel)
        }
        .sheet(isPresented: $showManageGifts) {
            ManageGiftsSheet(person: editedModel)
        }
    }
}
