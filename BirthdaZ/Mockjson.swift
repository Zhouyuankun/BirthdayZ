//
//  Mockjson.swift
//  Birthdaz
//
//  Created by 周源坤 on 2023/3/22.
//

import Foundation
import SwiftData

struct BirthRecord: Codable {
    let name: String
    let birth: String
    let birthdayCalendar: BirthdayCalendar
}

func dateFromISOString(_ isoString: String) -> Date? {
    let isoDateFormatter = ISO8601DateFormatter()
    isoDateFormatter.formatOptions = [.withFullDate]  // ignores time!
    return isoDateFormatter.date(from: isoString)  // returns nil, if isoString is malformed.
}

func strboolToBool(_ strbool: String) -> Bool? {
    if strbool == "true" {return true}
    if strbool == "false" {return false}
    return nil
}

func dateFromStr(dateString: String) -> Date {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.calendar = calendar
    formatter.dateFormat = "YYYY-MM-dd"
    return formatter.date(from: dateString)!
}


