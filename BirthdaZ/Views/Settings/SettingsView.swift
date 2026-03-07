//
//  SettingsView.swift
//  BirthdaZ
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
                        // TODO: Implement data dump
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
                logger.info("Notification authorization granted")
            } else if !authorized {
                logger.warning("Notification authorization denied")
            } else {
                if let error = error {
                    logger.error("Notification authorization error: \(error.localizedDescription)")
                }
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
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                self.un.add(request) { (error) in
                    if let error = error {
                        logger.error("Failed to add notification request: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}