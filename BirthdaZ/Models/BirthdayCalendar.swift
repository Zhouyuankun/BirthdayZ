//
//  BirthdayCalendar.swift
//  BirthdaZ
//
//  Extracted from Person.swift
//

import Foundation

public enum BirthdayCalendar: String, Codable, CaseIterable {
    case undefined
    case gregorian
    case nongli
}