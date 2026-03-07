//
//  ZodiacHelper.swift
//  BirthdaZ
//
//  Extracted from SettingsView.swift
//

import Foundation
import OSLog

fileprivate let logger = Logger(subsystem: "BirthdaZ", category: "ZodiacHelper")

func normalDate(fromYear year: Int, month: Int, day: Int) -> Date? {
    var normalCalendarDateComponents = DateComponents()
    normalCalendarDateComponents.year = year
    normalCalendarDateComponents.month = month
    normalCalendarDateComponents.day = day

    let normalCalendar = Calendar(identifier: .gregorian)
    return normalCalendar.date(from: normalCalendarDateComponents)
}

func getZodic(from normalDate: Date) -> String? {
    let chineseDate = convertToFullChineseDate(from: normalDate)
    guard let hyphen = chineseDate.firstIndex(of: "-") else {
        logger.warning("Date is not correctly formatted: \(chineseDate)")
        return nil
    }
    let startIndex = chineseDate.index(after: hyphen)
    let endIndex = chineseDate.index(chineseDate.endIndex, offsetBy: -2)
    let branchExtracted = chineseDate[startIndex ... endIndex]
    if let zodiac = branchNameToZodiac(String(branchExtracted)) {
        return zodiac
    }
    logger.warning("Cannot convert \(chineseDate) to a zodiac sign")
    return nil
}

func branchNameToZodiac(_ branch: String) -> String? {
    let dict = [
        "zi": "rat",
        "chou": "ox",
        "yin": "tiger",
        "mao": "rabbit",
        "chen": "dragon",
        "si": "snake",
        "wu": "horse",
        "wei": "goat",
        "shen": "monkey",
        "you": "rooster",
        "xu": "dog",
        "hai": "pig"
    ]
    return dict[branch]
}

func convertToFullChineseDate(from normalDate: Date) -> String {
    let chineseCalendar = Calendar(identifier: .chinese)
    let formatter = DateFormatter()
    formatter.calendar = chineseCalendar
    formatter.dateStyle = .full
    let chineseDate = formatter.string(from: normalDate)
    return chineseDate
}

func getFormatChineseDate(from birthDate: Date) -> String {
    let chineseCalendar = Calendar(identifier: .chinese)
    let formatter = DateFormatter()
    formatter.calendar = chineseCalendar
    formatter.dateFormat = "YYYY-MM-dd"
    return formatter.string(from: birthDate)
}

func getNextChineseDate(from birthDate: Date) -> Date {
    let chineseCalendar = Calendar(identifier: .chinese)
    let formatter = DateFormatter()
    formatter.calendar = chineseCalendar
    formatter.dateFormat = "YYYY-MM-dd"
    return Date()
}

func getstrdate(date: Date, dateFormatStr: String) -> String {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.calendar = calendar
    formatter.dateFormat = dateFormatStr
    return formatter.string(from: date)
}