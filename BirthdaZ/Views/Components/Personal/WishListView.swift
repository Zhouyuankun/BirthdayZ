//
//  WishListView.swift
//  BirthdaZ
//
//  Extracted from PersonalView.swift
//

import SwiftUI

struct WishListView: View {
    let model: Person?

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("愿望清单")
                    .bold()
                Spacer()
            }
            Divider()
        }
    }
}