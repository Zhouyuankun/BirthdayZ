//
//  PersonalView.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2/20/25.
//

import SwiftUI

struct PersonalView: View {
    let editedModel: Person

    @State var safeAreaInsets: EdgeInsets = .init()
    @State var scrollOffset: CGFloat = 0

    init(editedModel: Person? = nil) {
        if let editedModel = editedModel {
            self.editedModel = editedModel
        } else {
            self.editedModel = Person(name: "未命名", nickname: "无", gender: .male, birthDate: .now, birthdayCalendar: .undefined, themeColor: ColorComponents.fromColor(Color.getRandomColor()))
        }
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                PersonalPage(editedModel: editedModel)
            }
            .background(LinearGradient(
                gradient: Gradient(colors: [editedModel.themeColor.color.opacity(0.6), Color.white.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y
            } action: { oldValue, newValue in
                scrollOffset = newValue
            }
            .overlay {
                VStack {
                    self.navigation(safeAreaTop: proxy.safeAreaInsets.top, scrollOffset: scrollOffset, name: editedModel.name, color: editedModel.themeColor.color)
                    Spacer()
                }
            }
            .ignoresSafeArea()
        }
        #if os(iOS)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        #endif
    }

    func navigation(safeAreaTop: CGFloat, scrollOffset: CGFloat, name: String, color: Color) -> some View {
        let height = safeAreaTop + 44
        let progress: CGFloat

        progress = min(1, max(0, (scrollOffset - height - 20) / 44))

        return CustomNavBar(progress: Double(progress), name: name, bgColor: color)
            .frame(height: height)
    }

    struct CustomNavBar: View {
        let progress: Double
        let name: String
        let bgColor: Color

        var body: some View {
            ZStack(alignment: .bottom) {

                #if os(iOS)
                Color(uiColor: colorScheme == .light ? .white : .black)
                    .opacity(progress)
                    .contentShape(Rectangle())
                #elseif os(macOS)
                Color(nsColor: colorScheme == .light ? .white : .black)
                    .opacity(progress)
                    .contentShape(Rectangle())
                #endif


                bgColor
                    .opacity(progress / 3)
                    .contentShape(Rectangle())

                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                    }
                    .padding()

                    Spacer()

                }
                .accentColor(Color(white: colorScheme == .light ? 1 - progress : 1))
                .frame(height: 44)

                Text(name)
                    .font(.system(size: 16, weight: .semibold))
                    .opacity(progress)
                    .frame(height: 44, alignment: .center)
            }
            .frame(maxWidth: .infinity)
        }

        @Environment(\.colorScheme) var colorScheme
        @Environment(\.presentationMode) var presentationMode
    }
}

#if os(iOS)
import UIKit

/// For swipe left to right go back last page, when navigation bar is hidden
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
#endif

#Preview {
    PersonalView()
}