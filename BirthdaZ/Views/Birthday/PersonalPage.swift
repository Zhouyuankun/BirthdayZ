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

    @State var showDeletionAlert: Bool = false
    @State var showEditSheet: Bool = false

    var body: some View {
        VStack(spacing: 15) {
            Image("avatar")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .clipped()

            BaseInfoView(editedModel: editedModel)
                .personalCardStyle()

            BirthdayCountView(editedModel: editedModel)
                .personalCardStyle()

            GiftSentView(editedModel: editedModel)
                .personalCardStyle()

            WishListView(model: editedModel)
                .personalCardStyle()

            BirthdayMomentView(model: editedModel)
                .personalCardStyle()

            Button(action: {
                showEditSheet = true
            }, label: {
                Label("编辑", systemImage: "pencil")
            })
            .foregroundStyle(Color.adaptiveLabel)
            .buttonStyle(.personalButton)
            .padding(.top)

            Button(action: {
                showDeletionAlert = true
            }, label: {
                Label("删除", systemImage: "trash")
            })
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
        .sheet(isPresented: $showEditSheet) {
            EditPersonalView(editedModel: editedModel)
        }
    }
}