//
//  ColorComponents.swift
//  BirthdaZ
//
//  Extracted from Person.swift
//

import SwiftUI

public struct ColorComponents: Codable {
    public let red: Float
    public let green: Float
    public let blue: Float

    public var color: Color {
        Color(red: Double(red), green: Double(green), blue: Double(blue))
    }

    public static func fromColor(_ color: Color) -> ColorComponents {
        let resolved = color.resolve(in: EnvironmentValues())
        return ColorComponents(
            red: resolved.red,
            green: resolved.green,
            blue: resolved.blue
        )
    }
}