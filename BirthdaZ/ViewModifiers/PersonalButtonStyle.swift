//
//  PersonalButtonStyle.swift
//  BirthdaZ
//
//  Extracted from PersonalView.swift
//

import SwiftUI

struct PersonalButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.adaptiveSystemBackground)
            .clipShape(.rect(cornerRadius: 10))
            .padding(.horizontal)
    }
}

struct PersonalButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? Color.adaptiveLabel.opacity(0.3) : .clear)
            .background(Color.adaptiveSystemBackground)
            .clipShape(.rect(cornerRadius: 10))
            .compositingGroup()
            .padding(.horizontal)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
            .shadow(color: Color.adaptiveLabel.opacity(0.1), radius: 5, x: 0, y: 10)
    }
}

extension ButtonStyle where Self == PersonalButtonStyle {
    static var personalButton: PersonalButtonStyle {
        PersonalButtonStyle()
    }
}