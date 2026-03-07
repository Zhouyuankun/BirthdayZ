//
//  BirthdayMomentView.swift
//  BirthdaZ
//
//  Extracted from PersonalView.swift
//

import SwiftUI

struct BirthdayMomentView: View {
    let model: Person?

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("生日瞬间")
                    .bold()
                Spacer()
            }
            Divider()

            ScrollView(.horizontal) {
                HStack {
                    ForEach(1..<5) { idx in
                        ZStack {
                            Image("birthday_demo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 300)
                                .clipShape(.rect(cornerRadius: 10))

                            VStack {
                                Text("\(2025 - idx)年10月18日")
                                    .padding(.horizontal)
                                    .background(.ultraThinMaterial)
                                    .clipShape(.rect(cornerRadius: 5))
                                Spacer()

                                NavigationLink(destination: {
                                    Text("123")
                                }, label: {
                                    Text("进入回忆")
                                        .foregroundStyle(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .clipShape(.capsule)
                                })

                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}