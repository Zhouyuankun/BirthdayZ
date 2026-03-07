//
//  NongDate+Helpers.swift
//  BirthdaZ
//
//  Created by 周源坤 on 2/23/25.
//

import Foundation
import ZhDate

extension NongDate {
    
    func equalMonthAndDay(with anotherDate: NongDate) -> Bool {
        return self.lunarMonth == anotherDate.lunarMonth && self.leapMonth == anotherDate.leapMonth && self.lunarDay == anotherDate.lunarDay
    }
    
    var sameMonthAndDayInNextYear: NongDate {
        let todayDate = Date.now
        let components = Calendar.current.dateComponents([.year], from: todayDate)
        guard let yearNum = components.year else {
            return self
        }
        let thisYearBirthdayNongLi = self.sameMonthDayInYear(year: yearNum)
        if(thisYearBirthdayNongLi.toDate() > todayDate) {
            return thisYearBirthdayNongLi
        }
        let nextYearBirthdayNongLi = self.sameMonthDayInYear(year: yearNum + 1)
        return nextYearBirthdayNongLi
    }
    
    /// like "01-02" for 一月二日
    var monthdayNumString: String {
        let month = self.lunarMonth
        let day = self.lunarDay
        return (month < 10 ? "0\(month)" : "\(month)") + "-" + (day < 10 ? "0\(day)" : "\(day)")
    }
}
