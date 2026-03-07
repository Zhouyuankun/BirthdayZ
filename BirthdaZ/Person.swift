//
//  BirthdayModel.swift
//  Birthdaz
//
//  Created by 周源坤 on 2024/7/2.
//

import SwiftData
import Foundation
import ZhDate
import SwiftUI

enum Gender: String, Codable, CaseIterable {
    case undefined
    case male
    case female
}

enum BirthdayCalendar: String, Codable, CaseIterable {
    case undefined
    case gregorian
    case nongli
}

@Model
final public class Person: Identifiable {
    @Attribute(.unique) public var id: String
    var name: String
    var nickname: String
    var gender: Gender
    var birthDate: Date
    var birthdayCalendar: BirthdayCalendar
    var themeColor: ColorComponents
    @Relationship(deleteRule: .cascade, inverse: \GiftModel.person) var sentGifts: [GiftModel]
    
    
    init(name: String, nickname: String, gender: Gender, birthDate: Date, birthdayCalendar: BirthdayCalendar, themeColor: ColorComponents, sentGifts: [GiftModel] = []) {
        self.id = UUID().uuidString
        self.name = name
        self.nickname = nickname
        self.gender = gender
        self.birthDate = birthDate
        self.birthdayCalendar = birthdayCalendar
        self.themeColor = themeColor
        self.sentGifts = sentGifts
    }
    
    @Transient var birthDateInChineseCalendar: NongDate {
        return self.birthDate.nongDate
    }
    
    @Transient var nextBirthday: Date {
        return self.birthDate.nextBirthday(birthdayCalendar: birthdayCalendar)
    }
    
    @Transient var daysToNextBirthday: Int {
        if isBirthdayToday { return 0 }
        return Calendar.current.numberOfDaysBetween(from: Date.now, to: self.nextBirthday)
    }
    
    @Transient var age: Int {
        return Calendar.current.dateComponents([.year], from: self.birthDate, to: Date.now).year! + 1
    }
    
    @Transient var isBirthdayToday: Bool {
        return self.birthDate.isBirthdayToday(birthdayCalendar: birthdayCalendar)
    }
    
}

struct ColorComponents: Codable {
    let red: Float
    let green: Float
    let blue: Float

    var color: Color {
        Color(red: Double(red), green: Double(green), blue: Double(blue))
    }

    static func fromColor(_ color: Color) -> ColorComponents {
        let resolved = color.resolve(in: EnvironmentValues())
        return ColorComponents(
            red: resolved.red,
            green: resolved.green,
            blue: resolved.blue
        )
    }
}
