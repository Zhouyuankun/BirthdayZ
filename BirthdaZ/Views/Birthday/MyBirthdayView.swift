//
//  MyBirthdayView.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2/21/25.
//

import SwiftUI

struct MyBirthdayView: View {
    @Environment(\.modelContext) private var context
    @State var myBirthDate: Date = Date.now
    @State var myBirthdayModel: Person?
    
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink(destination: {
                    if myBirthdayModel == nil {
                        PersonalView()
                    } else {
                        PersonalView(editedModel: myBirthdayModel!)
                    }
                }, label: {
                    if myBirthdayModel == nil {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray)
                                .padding()
                            Text("Input my birthday")
                        }
                        .frame(height: 300)
                    } else {
                        FriendCardView(item: myBirthdayModel!)
                            .frame(height: 300)
                    }
                })
            }
            .navigationTitle("我的生日")
            .task {
                guard let myBirthdayModelID = UserDefaults.loadBirthdayModelID() else {
                    return
                }
                //TODO:
                let results = BirthdayModelHandler.fetchBirthdays(mainContext: context, predicate: #Predicate { birthdayModel in
                    birthdayModel.id == myBirthdayModelID
                })
                myBirthdayModel = results.first
            }
        }
    }
}
