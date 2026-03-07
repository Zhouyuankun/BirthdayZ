//
//  Color+Platform.swift
//  BirthdaZ
//
//  Cross-platform color helpers for iOS and macOS
//

import SwiftUI

extension Color {
    /// Adaptive label color - works on both iOS and macOS
    static var adaptiveLabel: Color {
        #if os(iOS)
        return Color(uiColor: .label)
        #elseif os(macOS)
        return Color(nsColor: .labelColor)
        #endif
    }

    /// Adaptive system background color - works on both iOS and macOS
    static var adaptiveSystemBackground: Color {
        #if os(iOS)
        return Color(uiColor: .systemBackground)
        #elseif os(macOS)
        return Color(nsColor: .windowBackgroundColor)
        #endif
    }

    /// Adaptive secondary system background color
    static var adaptiveSecondarySystemBackground: Color {
        #if os(iOS)
        return Color(uiColor: .secondarySystemBackground)
        #elseif os(macOS)
        return Color(nsColor: .controlBackgroundColor)
        #endif
    }

    /// Create Color from platform-specific semantic color
    static func platformColor(light: Color, dark: Color) -> Color {
        // This will automatically adapt based on color scheme
        return Color.primary
    }
}