//
//  DateHelper.swift
//  MacroProject
//
//  Created by Ages on 15/10/24.
//

import Foundation

enum Weekday: Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

enum PhraseResult: String {
    case correct
    case incorrect
    case undefinedResult
    
    static func defaultCase() -> PhraseResult {
        return .undefinedResult
    }
}

struct DateHelper {
    static func formattedDateString(from date: Date = Date(), style: DateFormatter.Style = .full) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: date)
    }

    func assignDate(for card: PhraseCardEntity, result: PhraseResult) {
        let currentDate = Date()
        
        switch result {
        case .undefinedResult: // dari library to study
            if card.levelNumber == "0" {
                card.lastReviewedDate = nil
                card.nextReviewDate = currentDate
                card.levelNumber = "1"
            }
            else {
                print(".undefinedResult error")
            }
            
        case .incorrect: // study jawaban salah
            card.lastReviewedDate = currentDate
            card.nextReviewDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            card.levelNumber = "1"
            
        case .correct: // study jawaban benar
            switch card.levelNumber {
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
        }
        print("\ncard: \(card.phrase) \n- levelNumber:\(card.levelNumber) \n- nextReviewDate:\(String(describing: card.nextReviewDate)) \n- lastReviewedDate: \(String(describing: card.lastReviewedDate))\n") 
    }
    
    func nextWeekday(currentDate: Date, weekdays: [Weekday]) -> Date? {
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
