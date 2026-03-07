//
//  Gender.swift
//  BirthdaZ
//
//  Extracted from Person.swift
//

import Foundation

public enum Gender: String, Codable, CaseIterable {
    case undefined
    case male
    case female
}