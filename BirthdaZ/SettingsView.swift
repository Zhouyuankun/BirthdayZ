//
//  SettingsView.swift
//  Birthdaz
//
//  Created by 周源坤 on 2023/3/22.
//

import SwiftUI
import UniformTypeIdentifiers
import UserNotifications
import OSLog

fileprivate let logger = Logger(subsystem: "BirthdaZ", category: "SettingsView")

struct SettingsView: View {
    @Environment(\.modelContext) var context
    @State var enableNotification: Bool = false
    
    let un = UNUserNotificationCenter.current()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle(isOn: $enableNotification) {
                        Label("Notification", systemImage: "bell")
                    }
                    .onChange(of: enableNotification) { _,_ in
                        notifyUser()
                    }
                    
                    Button(action: {
                        
                        BirthdayModelHandler.saveMockedBirthdaysToDisk(mainContext: context)
                    }, label: {
                        Label("Load data", systemImage: "arrowshape.turn.up.right")
                    })
                    
                    Button(action: {
                        
                    }, label: {
                        Label("Dump data", systemImage: "arrowshape.turn.up.left")
                    })
                    
                    
                }
                Section {
                    Button(role: .destructive, action: {
                       
                        BirthdayModelHandler.deleteAllBirthdaysOnDisk(mainContext: context)
                    }, label: {
                        Label("Delete", systemImage: "trash")
                    })
                    
                }
            }
            .navigationTitle("设置")
        }
    }
    
    func notifyUser() {
        un.requestAuthorization(options: [.alert, .sound]) { (authorized, error) in
            if authorized {
                print("Authorized")
            } else if !authorized {
                print("Not authorized")
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        
        un.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                let id = "Birthdaz"
                let content = UNMutableNotificationContent()
                content.title = "Hello"
                content.subtitle = "This is notification"
                content.body = "I made it \(Date.now)"
                content.sound = UNNotificationSound.default
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
                var dateComponents = DateComponents()
                dateComponents.hour = 10
                dateComponents.minute = 30
                //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                self.un.add(request) { (error) in
                    if error != nil {
                        print(error?.localizedDescription as Any)
                    }
                }
            }
        }
    }
}

func normalDate(fromYear year: Int, month: Int, day: Int) -> Date {
  var normalCalendarDateComponents = DateComponents()
  normalCalendarDateComponents.year = year
  normalCalendarDateComponents.month = month
  normalCalendarDateComponents.day = day
  
  let normalCalendar = Calendar(identifier: .gregorian)
  let normalDate = normalCalendar.date(from: normalCalendarDateComponents)!
  return normalDate
}

func getZodic(from normalDate: Date) -> String {
    let chineseDate = convertToFullChineseDate(from: normalDate)
    guard let hyphen = chineseDate.firstIndex(of: "-") else {
        fatalError("\(chineseDate) is not correctly formatted, use DateFormatter.Style.full")
    }
    let startIndex = chineseDate.index(after: hyphen)
    let endIndex = chineseDate.index(chineseDate.endIndex, offsetBy: -2)
    let branchExtracted = chineseDate[startIndex ... endIndex]
    if let zodiac = branchNameToZodiac(String(branchExtracted)) {
        return zodiac
    }
    fatalError("Cannot convert \(chineseDate) to a zodiac sign")
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

func showOpenPanel() -> URL? {
    return nil
//    let openPanel = NSOpenPanel()
//    openPanel.allowedContentTypes = [UTType.json]
//    openPanel.allowsMultipleSelection = false
//    openPanel.canChooseDirectories = false
//    openPanel.canChooseFiles = true
//    let response = openPanel.runModal()
//    return response == .OK ? openPanel.url : nil
}

//func birthsToJSON(birthdaz: [Birthday]) -> Data? {
//    
//    var data: Data? = nil
//    let birthRecords = birthdaz.map {createBirthRecordFromBirthday(birthday: $0)}
//    let birthjson = BirthJSON(records: birthRecords)
//    let encoder = JSONEncoder()
//    encoder.keyEncodingStrategy = .convertToSnakeCase
//    do {
//        data = try encoder.encode(birthjson)
//    } catch {
//        
//    }
//    return data
//}

//func createBirthRecordFromBirthday(birthday: Birthday) -> BirthRecord {
//    return BirthRecord(name: birthday.name!, birth: getstrdate(date: birthday.day!), isLunar: birthday.isLunar ? "true" : "false")
//}

func getstrdate(date: Date, dateFormatStr: String) -> String {
    let calendar = Calendar.current
    let formatter = DateFormatter()
    formatter.calendar = calendar
    formatter.dateFormat = dateFormatStr
    return formatter.string(from: date)
}

func showSavePanel() -> URL? {
    return nil
//    let savePanel = NSSavePanel()
//    savePanel.allowedContentTypes = [UTType.json]
//    savePanel.canCreateDirectories = true
//    savePanel.isExtensionHidden = false
//    savePanel.allowsOtherFileTypes = false
//    savePanel.title = "Save your json"
//    savePanel.message = "Choose a folder and a name to store your json."
//    savePanel.nameFieldLabel = "File name:"
//    let response = savePanel.runModal()
//    return response == .OK ? savePanel.url : nil
}

//func getAllBirthdays() -> [Birthday] {
//    let request = Birthday.fetchRequest()
//    let viewContext = PersistenceController.shared.container.viewContext
//    let result = try! viewContext.fetch(request)
//    return result
//}

//func getNextBirthday() -> Birthday? {
//    var birthdaz = getAllBirthdays()
//    if birthdaz.count == 0 {
//        return nil
//    }
//    birthdaz.sort {getDaysToSolarBirthday(date: $0.day!) < getDaysToSolarBirthday(date: $1.day!)}
//    return birthdaz[0]
//}
