//
//  BTabView.swift
//  Birthdaz
//
//  Created by 周源坤 on 2024/7/7.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MyBirthdayView().tabItem {
                Label("我的生日", systemImage: "house")
            }
            PeopleListView().tabItem {
                Label("好友生日", systemImage: "person.3")
            }
            SettingsView().tabItem {
                Label("Settings", systemImage: "gear")
            }            
        }
    }
}
