//
//  Color+BirthdayModel.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2024/7/10.
//

import SwiftUI

extension Color {
    static func getRandomColor() -> Color {
        let redComponent = Double(arc4random() % 255) / 255
        let greenComponent = Double(arc4random() % 255) / 255
        let blueComponent = Double(arc4random() % 255) / 255
        return Color(red: redComponent, green: greenComponent, blue: blueComponent)
    }
}
