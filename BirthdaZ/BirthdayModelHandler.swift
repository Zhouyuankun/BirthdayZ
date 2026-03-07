//
//  BirthdayModelHandler.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2024/7/9.
//

import Foundation
import SwiftData
import OSLog

fileprivate let logger = Logger(subsystem: "BirthdaZ", category: "BirthdayModelHandler")

final actor BirthdayModelHandler {
    
    @MainActor
    static func fetchBirthdays(mainContext: ModelContext, predicate: Predicate<Person>? = nil, sort: [SortDescriptor<Person>] = []) -> [Person] {
        let fetchRequest = FetchDescriptor<Person>(predicate: predicate, sortBy: sort)
        do {
            let birthdays = try mainContext.fetch(fetchRequest)
            logger.debug("fetch success")
            return birthdays
        } catch {
            logger.error("fetch failed")
            return []
        }
    }
    
    @MainActor 
    static func insertBirthdayToDisk(mainContext: ModelContext, birthdayModel: Person) {
        mainContext.insert(birthdayModel)
        do {
            try mainContext.save()
        } catch {
            logger.error("save failed")
        }
        logger.debug("insert complete")
    }
    
    @MainActor
    static func updateBirthdayToDisk(mainContext: ModelContext, birthdayModel: Person) {
        let uuidString = birthdayModel.id
        let results = BirthdayModelHandler.fetchBirthdays(mainContext: mainContext, predicate: #Predicate {
            $0.id == uuidString
        })
        if let result = results.first {
            result.update(with: birthdayModel)
            do {
               try mainContext.save()
                logger.debug("update birthdayModel completed")
            } catch {
                logger.error("save failed")
            }
        } else {
            Self.insertBirthdayToDisk(mainContext: mainContext, birthdayModel: birthdayModel)
        }
    }
    
    @MainActor
    static func deleteBirthdayInoDisk(mainContext: ModelContext, persistentID: PersistentIdentifier) {
        let results = BirthdayModelHandler.fetchBirthdays(mainContext: mainContext, predicate: #Predicate {
            $0.persistentModelID == persistentID
        })
        if let result = results.first {
            mainContext.delete(result)
            do {
               try mainContext.save()
                logger.debug("delete birthdayModel completed")
            } catch {
                logger.error("delete failed")
            }
        } else {
            //No ID found
            logger.debug("no model id found on database")
        }
    }
    
    
    @MainActor 
    static func deleteAllBirthdaysOnDisk(mainContext: ModelContext) {
        let fetchRequest = FetchDescriptor<Person>()
        do {
            let birthdays = try mainContext.fetch(fetchRequest)
            for birthday in birthdays {
                mainContext.delete(birthday)
            }
            try mainContext.save()
        } catch {
            logger.error("delete all birthdayModel failed")
            return
        }
        logger.debug("delete birthdayModel completed")
    }
    
    @MainActor
    static func dumpBirthdaysToDisk(mainContext: ModelContext) throws {
        let recorded = Self.fetchBirthdays(mainContext: mainContext)
        let jsonEncoder = JSONEncoder()
        //jsonEncoder.encode(recorded)
    }
}

extension BirthdayModelHandler {
    @MainActor
    static func saveMockedBirthdaysToDisk(mainContext: ModelContext) {
        let mockedModels = Person.mockedModels()
        for mockedModel in mockedModels {
            mainContext.insert(mockedModel)
        }
        do {
            try mainContext.save()
        } catch {
            logger.error("failed to save mocked data")
        }
        
        logger.debug("save \(mockedModels.count) mocked")
    }
}

extension Person {
    func update(with model: Person) {
        guard self.id == model.id else {
            logger.log("Can't update birthday model with different id")
            return
        }
        self.name = model.name
        self.nickname = model.nickname
        self.gender = model.gender
        self.birthDate = model.birthDate
        self.birthdayCalendar = model.birthdayCalendar
        self.themeColor = model.themeColor
    }
}
