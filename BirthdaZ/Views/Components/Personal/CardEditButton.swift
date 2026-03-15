//
//  CardEditButton.swift
//  BirthdaZ
//
//  Edit button for card headers
//

import SwiftUI
import SwiftData

struct CardEditButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "pencil.circle")
                .font(.title3)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.secondary)
        }
        .buttonStyle(.plain)
    }
}