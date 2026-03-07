//
//  PeopleListView.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2023/3/22.
//

import SwiftUI
import SwiftData
import ZhDate
import OSLog

fileprivate let logger = Logger(subsystem: "BirthdaZ", category: "PeopleListView")

struct PeopleListView: View {
    @Environment(\.modelContext) private var context

    @Query var birthdays: [Person]

    var sortedBirthdays: [Person] {
        return birthdays.sorted {
            $0.daysToNextBirthday < $1.daysToNextBirthday
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, content: {
                    ForEach(sortedBirthdays) { item in
                        NavigationLink(destination: {
                            PersonalView(editedModel: item)
                        }, label: {
                            FriendCardView(item: item)
                                .frame(height: 150)
                        })
                        .swipeActions {
                            Action(symbolImage: "trash.fill", tint: .white, background: .red) { resetPosition in
                                resetPosition.toggle()
                                context.delete(item)
                                do {
                                    try context.save()
                                } catch {
                                    logger.error("Failed to save context after delete: \(error.localizedDescription)")
                                }
                            }
                        }
                        .tint(Color.adaptiveLabel)
                    }
                })
            }
            .scrollIndicators(.hidden)
            .navigationTitle("好友生日")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing, content: {
                    NavigationLink(destination: {
                        PersonalView()
                    }, label: {
                        Image(systemName: "plus")
                    })
                })
                #elseif os(macOS)
                ToolbarItem(placement: .automatic, content: {
                    NavigationLink(destination: {
                        PersonalView()
                    }, label: {
                        Image(systemName: "plus")
                    })
                })
                #endif
            }
            .animation(.smooth, value: sortedBirthdays)
        }
    }
}

#Preview {
    return PeopleListView()
}