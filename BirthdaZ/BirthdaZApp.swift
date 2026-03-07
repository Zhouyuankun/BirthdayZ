//
//  BirthdaZApp.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2024/7/8.
//

import SwiftUI
import SwiftData
#if canImport(Appkit)
import Appkit
#endif

@main
struct BirthdazApp: App {
    @Environment(\.openWindow) private var openWindow

    var body: some Scene {
        WindowGroup(id: Constant.WindowID_BirthdazPanel.rawValue) {
            ContentView()
                .modelContainer(for: [Person.self])
        }
        #if os(macOS)
        MenuBarExtra(content: {
            Button("Show panel") {
                openWindow(id: WindowID.birthdazPanel.rawValue)
            }
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }, label: {
            Label("Birthdaz", systemImage: "gift.fill")
        })
        #endif
    }
}
