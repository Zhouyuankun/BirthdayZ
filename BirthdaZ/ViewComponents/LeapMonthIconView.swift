//
//  LeapMonthIconView.swift
//  BirthdaZ
//
//  Extracted from PeopleListView.swift
//

import SwiftUI

struct LeapMonthIconView: View {
    var body: some View {
        Text("Leap")
            .font(.caption)
            .padding(.all, 5)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}