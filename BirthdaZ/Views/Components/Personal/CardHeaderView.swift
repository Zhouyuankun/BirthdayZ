//
//  CardHeaderView.swift
//  BirthdaZ
//
//  Reusable header with title and optional edit button
//

import SwiftUI
import SwiftData

struct CardHeaderView: View {
    let title: String
    var editAction: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .bold()
            Spacer()
            if let action = editAction {
                CardEditButton(action: action)
            }
        }
    }
}