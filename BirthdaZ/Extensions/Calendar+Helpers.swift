//
//  Calendar+Helpers.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2/23/25.
//

import Foundation

extension Calendar {
    func numberOfDaysBetween(from: Date, to: Date) -> Int {
        let numberOfDays = dateComponents([.day], from: from, to: to)
        return (numberOfDays.day ?? 0) + 1
    }
}
