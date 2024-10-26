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
    static func formattedDateString(from date: Date?, style: DateFormatter.Style = .full) -> String {
        guard let date = date else {
            return "N/A" // or return an empty string ""
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: date)
    }


    func assignDate(for card: PhraseCardEntity, result: PhraseResult) {
        let currentDate = Date()
        
        switch result {
        case .undefinedResult: // from library to study
            if card.levelNumber == "0" {
                card.lastReviewedDate = nil
                card.nextReviewDate = currentDate
                card.levelNumber = "1"
            } else {
                print(".undefinedResult error")
            }
            
        case .incorrect: // study, incorrect answer
            card.lastReviewedDate = currentDate
            card.nextReviewDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
            card.levelNumber = "1"
            
        case .correct: // study, correct answer
            card.lastReviewedDate = currentDate
            
            switch card.levelNumber {
            case "1":
                card.nextReviewDate = nextSpecificWeekday(currentDate: currentDate, weekdays: [.tuesday, .thursday])
                card.levelNumber = "2"
                
            case "2":
                card.nextReviewDate = nextSpecificWeekday(currentDate: currentDate, weekdays: [.friday])
                card.levelNumber = "3"
                
            case "3":
                if let nextFriday = nextSpecificWeekday(currentDate: currentDate, weekdays: [.friday]) {
                    card.nextReviewDate = Calendar.current.date(byAdding: .day, value: 14, to: nextFriday)
                }
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

    // Find the next specific weekday while keeping the timezone adjustment
    func nextSpecificWeekday(currentDate: Date, weekdays: [Weekday]) -> Date? {
        let calendar = Calendar.current
        var nextDate: Date? = nil

        for day in weekdays {
            // Find the next date for the specified weekday(s)
            if let nextDay = calendar.nextDate(after: currentDate, matching: DateComponents(weekday: day.rawValue), matchingPolicy: .nextTime) {
                // Ensure we get the earliest available day in the future
                if nextDate == nil || nextDay < nextDate! {
                    nextDate = nextDay
                }
            }
        }

//         Adjust nextDate to be in the local timezone
        if let nextDate = nextDate {
            return calendar.date(bySettingHour: 9, minute: 0, second: 0, of: nextDate) // Adjust to 9:00 AM local time
        }
        
        return nextDate
    }
}
