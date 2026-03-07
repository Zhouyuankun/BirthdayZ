//
//  PersonalCardModifier.swift
//  BirthdaZ
//
//  Extracted from PersonalView.swift
//

import SwiftUI

struct PersonalCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.adaptiveSystemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal)
            .shadow(color: Color.adaptiveLabel.opacity(0.1), radius: 5, x: 0, y: 10)
    }
}

extension View {
    func personalCardStyle() -> some View {
        self.modifier(PersonalCardModifier())
    }
}