//
//  ContentView.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2024/7/8.
//

import SwiftUI
import CoreData
import SwiftData

struct ContentView: View {
    var body: some View {
        #if os(iOS)
        MainTabView()
        #elseif os(macOS)
        MainNavView()
        #endif
    }
}

enum MenuItemTag {
    case homeTag
    case addTag
    case setTag
}

struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let tag: MenuItemTag
    let title: String
    let systemImg: String
}

let menuItems = [
    MenuItem(tag: .homeTag, title: "Home", systemImg: "house"),
    MenuItem(tag: .addTag, title: "Add", systemImg: "plus"),
    MenuItem(tag: .setTag, title: "Settings", systemImg: "gear")
]

@ViewBuilder func getDetailView(for tag: MenuItemTag) -> some View {
    switch tag {
    case .homeTag:
        PeopleListView()
    case .addTag:
        PersonalView()
    case .setTag:
        SettingsView()
    }
}

#Preview {
    return ContentView()
}
