//
//  GiftModel.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2/23/25.
//

import Foundation
import SwiftData

enum GiftType: String, Codable, CaseIterable {
    case electronics
    case foods
    case money
    case clothing
    case books
    case toys
    case jewelry
    case cosmetics
    case homeAppliances
    case furniture
    case subscriptions
    case giftCards
    case sportsEquipment
    case collectibles
    case beautyProducts
    case petSupplies
    case others
}

@Model
public final class GiftModel {
    @Attribute(.unique) public var id: String
    
    var person: Person
    var sentDate: Date
    var giftType: GiftType
    var giftDesc: String
    
    init(person: Person, sentDate: Date, giftType: GiftType, giftDesc: String) {
        self.id = UUID().uuidString
        self.person = person
        self.sentDate = sentDate
        self.giftType = giftType
        self.giftDesc = giftDesc
    }
}
