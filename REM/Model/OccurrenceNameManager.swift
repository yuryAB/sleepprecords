//
//  OccurrenceNameManager.swift
//  REM
//
//  Created by yury antony on 27/05/25.
//

import Foundation

final class OccurrenceNameManager {
    private static let calendar = Calendar.current
    private static let weekdayKeys: [Int: String] = [1: "Sunday", 2: "Monday", 3: "Tuesday", 4: "Wednesday", 5: "Thursday", 6: "Friday", 7: "Saturday"]

    static func generateOccurrenceName(for date: Date = Date()) -> String {
        let period = localizedPeriod(for: date)
        let weekday = localizedWeekday(for: date)
        return formattedName(period: period, weekday: weekday)
    }
    
    private static func periodKey(from hour: Int) -> String {
        switch hour {
        case 6..<12:   return "Morning"
        case 12..<18:  return "Afternoon"
        case 18..<21:  return "Evening"
        case 21..<24:  return "Night"
        default:       return "Early Morning"
        }
    }
    
    private static func localizedPeriod(for date: Date) -> String {
        let hour = Self.calendar.component(.hour, from: date)
        let periodKey = periodKey(from: hour)
        return periodKey.localizable
    }
    
    private static func localizedWeekday(for date: Date) -> String {
        let weekdayIndex = Self.calendar.component(.weekday, from: date)
        let weekdayKey = Self.weekdayKeys[weekdayIndex] ?? ""
        return weekdayKey.localizable
    }
    
    private static func formattedName(period: String, weekday: String) -> String {
        if LocalizationManager.currentLanguage == .portuguese {
            return "\(period) de \(weekday)"
        } else {
            return "\(weekday) - \(period)"
        }
    }
}
