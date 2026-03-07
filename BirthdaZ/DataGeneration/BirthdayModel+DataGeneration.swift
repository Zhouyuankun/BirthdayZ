//
//  BirthdayModel+DataGeneration.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2024/7/9.
//

import Foundation
import OSLog
import SwiftUI

fileprivate let logger = Logger(subsystem: "BirthdaZ", category: "BirthdayModel+DataGeneration")

extension Person {
    static func defaultModel() -> Person {
        return Person(name: "XXX", nickname: "XXX", gender: .male, birthDate: Date.now, birthdayCalendar: .undefined, themeColor: ColorComponents.fromColor(Color.gray))
    }
    
    static func mockedModels() -> [Person] {
        guard let url = Bundle.main.url(forResource: "birthdays", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            logger.error("Failed to load birthdays.json from bundle")
            return []
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            var mocked: [Person] = []
            let birthRecords = try decoder.decode([BirthRecord].self, from: data)
            for birthRecord in birthRecords {
                guard let birthdate = dateFromISOString(birthRecord.birth) else {
                    continue;
                }
                let birthdayModel = Person(name: birthRecord.name, nickname: birthRecord.name + ".nick", gender: .male, birthDate: birthdate, birthdayCalendar: birthRecord.birthdayCalendar, themeColor: ColorComponents.fromColor(Color.getRandomColor()))
                mocked.append(birthdayModel)
            }
            return mocked
        } catch {
            logger.error("decode mock json failed: \(error.localizedDescription)")
        }
        return []
    }
    
}

