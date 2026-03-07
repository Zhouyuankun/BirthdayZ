//
//  Date+Helpers.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2/23/25.
//

import Foundation
import ZhDate

extension Date {
    func sameMonthDayInYear(year: Int) -> Date {
        let dateComponents = Calendar.current.dateComponents([.month, .day], from: self)
        let monthNum = dateComponents.month
        let dayNum = dateComponents.day
        return Calendar.current.date(from: DateComponents(year: year, month: monthNum, day: dayNum))!
    }
    
    func equalMonthAndDay(with anotherDate: Date) -> Bool {
        let calendar = Calendar.current
        let timeZone = TimeZone.current  // Ensure you are using the correct time zone

        let dateComponents = calendar.dateComponents(in: timeZone, from: self)
        let dateComponents_another = calendar.dateComponents(in: timeZone, from: anotherDate)

        return dateComponents.month == dateComponents_another.month && dateComponents.day == dateComponents_another.day
    }
    
    var nongDate: NongDate {
        return NongDate.fromDate(date: self)
    }
    
    var sameMonthAndDayInNextYear: Date {
        let todayDate = Date.now
        let yearNum = Calendar.current.dateComponents([.year], from: todayDate).year!
        let thisYearBirthdayGregorian = self.sameMonthDayInYear(year: yearNum)
        if(thisYearBirthdayGregorian > todayDate) {
            return thisYearBirthdayGregorian
        }
        let nextYearBirthdayGregorian = self.sameMonthDayInYear(year: yearNum + 1)
        return nextYearBirthdayGregorian
    }
    
    func isBirthdayToday(birthdayCalendar: BirthdayCalendar) -> Bool {
        if(birthdayCalendar == .nongli) {
            return self.nongDate.equalMonthAndDay(with: NongDate.today())
        } else {
            return self.equalMonthAndDay(with: Date.now)
        }
    }
    
    func nextBirthday(birthdayCalendar: BirthdayCalendar) -> Date {
        if isBirthdayToday(birthdayCalendar: birthdayCalendar) {
            return .now
        }
        if(birthdayCalendar == .nongli) {
            return self.nongDate.sameMonthAndDayInNextYear.toDate()
        } else {
            return self.sameMonthAndDayInNextYear
        }
    }
    
    func dateToString(stringFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = stringFormat
        return formatter.string(from: self)
    }
    
    var monthdayCHString: String {
        // Create a Calendar instance
        let calendar = Calendar.current
        
        // Extract the components of the date (year, month, day)
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        
        // Create arrays for Chinese month names and day names
        let chineseMonths = ["", "一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
        let chineseDays = ["", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "二十一", "二十二", "二十三", "二十四", "二十五", "二十六", "二十七", "二十八", "二十九", "三十", "三十一"]
        
        // Extract month and day from the components
        guard let month = components.month, let day = components.day else {
            return ""
        }
        
        // Get the Chinese month and day names
        let chineseMonth = chineseMonths[month]
        let chineseDay = chineseDays[day]
        
        // Return the formatted string
        return "\(chineseMonth)\(chineseDay)日"
    }
}
