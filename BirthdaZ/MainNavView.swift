//
//  MainNavView.swift
//  Birthdaz
//
//  Created by 周源坤 on 2024/7/7.
//
import SwiftUI

struct MainNavView: View {
    @State var menuItemId: MenuItem.ID?
    
    func searchMenuItem(for id: UUID) -> MenuItem? {
        return menuItems.first(where: {$0.id == id})
    }
    
    var body: some View {
        NavigationSplitView(sidebar: {
            List(menuItems, selection: $menuItemId) { menuItem in
                Label(menuItem.title, systemImage: menuItem.systemImg)
            }
        }, detail: {
            if let menuItemId = menuItemId, let menuItem = searchMenuItem(for: menuItemId) {
                getDetailView(for: menuItem.tag)
            } else {
                VStack {
                    Text("Please click the menu").padding(.vertical)
                    Image("Z_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Text("Designed by")
                    Text("Celeglow")
                        .bold()
                    Text("All rights reserved to Celeglow")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        })
        .background(VisualEffect())
    }
}

struct VisualEffect: NSViewRepresentable {
    func makeNSView(context: Self.Context) -> NSView { return NSVisualEffectView() }
    func updateNSView(_ nsView: NSView, context: Context) { }
}

#Preview {
    MainNavView()
}



