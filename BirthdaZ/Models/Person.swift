//
//  Person.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2024/7/2.
//

import SwiftData
import Foundation
import ZhDate
import SwiftUI

@Model
final public class Person: Identifiable {
    @Attribute(.unique) public var id: String
    public var name: String
    public var nickname: String
    public var gender: Gender
    public var birthDate: Date
    public var birthdayCalendar: BirthdayCalendar
    public var themeColor: ColorComponents
    @Relationship(deleteRule: .cascade, inverse: \GiftModel.person) public var sentGifts: [GiftModel]


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

    @Transient public var birthDateInChineseCalendar: NongDate {
        return self.birthDate.nongDate
    }

    @Transient public var nextBirthday: Date {
        return self.birthDate.nextBirthday(birthdayCalendar: birthdayCalendar)
    }

    @Transient public var daysToNextBirthday: Int {
        if isBirthdayToday { return 0 }
        return Calendar.current.numberOfDaysBetween(from: Date.now, to: self.nextBirthday)
    }

    @Transient public var age: Int {
        let components = Calendar.current.dateComponents([.year], from: self.birthDate, to: Date.now)
        return (components.year ?? 0) + 1
    }

    @Transient public var isBirthdayToday: Bool {
        return self.birthDate.isBirthdayToday(birthdayCalendar: birthdayCalendar)
    }
}