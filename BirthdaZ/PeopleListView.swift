//
//  HomeView.swift
//  Birthdaz
//
//  Created by 周源坤 on 2023/3/22.
//

import SwiftUI
import SwiftData
import ZhDate

enum RefreshState {
    case refreshing
    case refreshed
}

struct PeopleListView: View {
    @Environment(\.modelContext) private var context
    @State private var refreshState: RefreshState = .refreshed
    @State private var refreshTrigger = true
    
    @Query var birthdays: [Person] // Fetch all birthdays

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
                                try! context.save()
                            }
                        }
                        .tint(Color(UIColor.label))
                    }
                })
            }
            .scrollIndicators(.hidden)
            .navigationTitle("好友生日")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing, content: {
                    NavigationLink(destination: {
                        PersonalView()
                    }, label: {
                        Image(systemName: "plus")
                    })
                })
            }
            .animation(.smooth, value: sortedBirthdays)
        }
        
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}



#Preview {
    return PeopleListView()
}

struct FriendCardView: View {
    @Environment(\.colorScheme) private var colorScheme
    let item: Person
    
    var body: some View {
        let themeColor = item.themeColor.color
        HStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(themeColor.opacity(0.3))
                    .shadow(color: themeColor, radius: 5, x: -5, y: 0)
                VStack(spacing: 10) {
                    Text(item.name)
                        .font(.title3)
                    Text(item.nextBirthday.dateToString(stringFormat: "YYYY-MM-dd"))
                    if (item.birthdayCalendar == .nongli) {
                        HStack {
                            LeapMonthIconView()
                            Text("\(item.birthDateInChineseCalendar.monthdayNumString)")
                                .font(.subheadline)
                        }
                        
                    }
                    Text("\(item.age)")
                        .font(.title)
                }
            }
            ZStack {
                Rectangle()
                    .fill(themeColor.opacity(0.1))
                    .shadow(color: themeColor, radius: 5, x: 5, y: 0)
                
                VStack {
                   
                    if item.isBirthdayToday {
                        
                        Text("Happy birthday !")
                            .font(.title)
                        Image(systemName: "gift")
                            .font(.title)
                        
                    } else {
                        let daycnt = item.daysToNextBirthday
                        let progresscnt = Int(Double(366 - daycnt) / Double(366) * 100)
                        Text("Next birthday in \(daycnt) days")
                            .font(.caption)
                        AnimatedRingView(ring: Ring(progress: CGFloat(progresscnt), value: "Steps", keyIcon: "figure.walk", keyColor: themeColor))
                            .frame(width: 75)
                            .padding(10)
                    }
                }
                .padding()
                .cornerRadius(10)
            }
        }
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct LeapMonthIconView: View {
    var body: some View {
        Text("Leap")
            .font(.caption)
            .padding(.all, 5)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}
