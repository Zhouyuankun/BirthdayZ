//
//  Item.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2024/7/8.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
