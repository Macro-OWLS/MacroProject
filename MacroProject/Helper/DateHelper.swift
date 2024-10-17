//
//  DateHelper.swift
//  MacroProject
//
//  Created by Ages on 15/10/24.
//

import Foundation

struct DateHelper {
    static func formattedDateString(from date: Date = Date(), style: DateFormatter.Style = .full) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: date)
    }

    func assignDate(for card: PhraseCardEntity) {
        let currentDate = Date()

        switch card.levelNumber {
        case "0":
            card.lastReviewedDate = nil
            card.nextReviewDate = currentDate
            card.levelNumber = "1"
            
        case "1":
            card.lastReviewedDate = currentDate
            card.nextReviewDate = nextWeekday(currentDate: currentDate, weekdays: [.tuesday, .thursday])
            card.levelNumber = "2"
            
        case "2":
            card.lastReviewedDate = currentDate
            card.nextReviewDate = nextWeekday(currentDate: currentDate, weekdays: [.friday])
            card.levelNumber = "3"
            
        case "3":
            card.lastReviewedDate = currentDate
            card.nextReviewDate = Calendar.current.date(byAdding: .day, value: 14, to: nextWeekday(currentDate: currentDate, weekdays: [.friday])!)
            card.levelNumber = "4"
            
        case "4":
            card.lastReviewedDate = currentDate
            card.nextReviewDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
            card.levelNumber = "5"
            
        case "5":
            card.lastReviewedDate = currentDate
            card.nextReviewDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)
            
        default:
            card.nextReviewDate = nil
        }
        print("\ncard: \(card.phrase) \n- levelNumber:\(card.levelNumber) \n- nextReviewDate:\(String(describing: card.nextReviewDate)) \n- lastReviewedDate: \(String(describing: card.lastReviewedDate))\n")
    }
    
    private func nextWeekday(currentDate: Date, weekdays: [Weekday]) -> Date? {
        var nextDate: Date? = nil
        let calendar = Calendar.current
        for day in weekdays {
            if let nextDay = calendar.nextDate(after: currentDate, matching: DateComponents(weekday: day.rawValue), matchingPolicy: .nextTime) {
                if nextDate == nil || nextDay < nextDate! {
                    nextDate = nextDay
                }
            }
        }
        return nextDate
    }
}

// Weekday enum for convenience
enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}
