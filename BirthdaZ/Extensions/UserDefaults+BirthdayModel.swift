//
//  UserDefaults+BirthdayModel.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2024/7/9.
//
import Foundation

extension UserDefaults {
    static func saveBirthdayModelID(birthdayModelID: String) {
        Self.standard.set(birthdayModelID, forKey: Constant.UDKey_MyBirthdayModelID.rawValue)
    }
    
    static func loadBirthdayModelID() -> String? {
        return Self.standard.string(forKey: Constant.UDKey_MyBirthdayModelID.rawValue)
    }
    
}
