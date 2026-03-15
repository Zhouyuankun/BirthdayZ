//
//  GiftModel.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2/23/25.
//

import Foundation
import SwiftData
import SwiftUI

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

    var symbol: String {
        switch self {
        case .electronics: return "laptopcomputer"
        case .foods: return "fork.knife"
        case .money: return "banknote"
        case .clothing: return "tshirt"
        case .books: return "book"
        case .toys: return "gamecontroller"
        case .jewelry: return "gem"
        case .cosmetics: return "scissors"
        case .homeAppliances: return "house"
        case .furniture: return "couch"
        case .subscriptions: return "arrow.trianglehead.clockwise"
        case .giftCards: return "giftcard"
        case .sportsEquipment: return "figure.run"
        case .collectibles: return "star"
        case .beautyProducts: return "sparkles"
        case .petSupplies: return "pawprint"
        case .others: return "gift"
        }
    }

    var color: Color {
        switch self {
        case .electronics: return .blue
        case .foods: return .orange
        case .money: return .green
        case .clothing: return .purple
        case .books: return .brown
        case .toys: return .pink
        case .jewelry: return .cyan
        case .cosmetics: return .mint
        case .homeAppliances: return .indigo
        case .furniture: return .teal
        case .subscriptions: return .red
        case .giftCards: return .yellow
        case .sportsEquipment: return .green
        case .collectibles: return .orange
        case .beautyProducts: return .pink
        case .petSupplies: return .brown
        case .others: return .gray
        }
    }
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
