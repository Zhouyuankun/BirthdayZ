//
//  WishListView.swift
//  BirthdaZ
//
//  Extracted from PersonalView.swift
//

import SwiftUI

struct WishListView: View {
    let model: Person?
    var editAction: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 10) {
            CardHeaderView(title: "愿望清单", editAction: editAction)
            Divider()
        }
    }
}