//
//  LevelViewModel.swift
//  MacroProject
//
//  Created by Agfi on 13/10/24.
//

import Foundation
import SwiftUI
import Combine

final class LevelViewModel: ObservableObject {
    @Published var levels: [Level] = [
        .init(level: 1, title: "Level 1", description: "Learn this everyday"),
        .init(level: 2, title: "Level 2", description: "Learn this every Tuesday & Thursday"),
        .init(level: 3, title: "Level 3", description: "Learn this every Friday"),
        .init(level: 4, title: "Level 4", description: "Learn this biweekly on Friday"),
        .init(level: 5, title: "Level 5", description: "Learn this once a month")
    ]
    
    @Published var selectedLevel: Level = .init(level: 0, title: "", description: "")
    @Published var showAlert: Bool = false
    @Published var showStudyConfirmation: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var isLoading = false
    
    private let topicStudyViewModel: TopicStudyViewModel = TopicStudyViewModel()

    func checkDateForLevelAccess(level: Level) {
        let currentDay = getCurrentDayOfWeek()

        switch level.level {
        case 2:
            if (currentDay != "Tuesday" && currentDay != "Thursday") {
                showAlert = true
                alertTitle = "Not Available Yet"
                alertMessage = "You can only access this on Tuesday & Thursday"
            }
        case 3, 4, 5:
            if (currentDay != "Friday") {
                showAlert = true
                alertTitle = "Not Available Yet"
                alertMessage = "You can only access this on Friday"
            }
        default:
            showAlert = false
        }
    }
    
    func resetAlert() {
        showAlert = false
    }
    
    
    func setSelectedLevel(level: Level) {
        selectedLevel = level
    }
    
    /// Returns the appropriate background color based on the level and current day
    func setBackgroundColor(for level: Level) -> Color {
        let currentDay = getCurrentDayOfWeek()
        
        switch level.level {
        case 1:
            return .darkcream // Level 1 has background cream every day
        case 2:
            return (currentDay == "Tuesday" || currentDay == "Thursday") ? .darkcream : .cream
        case 3:
            return currentDay == "Friday" ? .darkcream : .cream
        case 4, 5:
            return currentDay == "Friday" && topicStudyViewModel.checkIfAnyAvailableTopicsForToday(level: level) ? .darkcream : .cream
        default:
            return .gray
        }
    }
    
    /// Returns the appropriate text color based on the level and current day
    func setTextColor(for level: Level) -> Color {
        let currentDay = getCurrentDayOfWeek()
        
        switch level.level {
        case 1:
            return .black // Level 1 has black text every day
        case 2:
            return (currentDay == "Tuesday" || currentDay == "Thursday") ? .black : .brown
        case 3:
            return currentDay == "Friday" ? .black : .brown
        case 4, 5:
            return currentDay == "Friday" && topicStudyViewModel.checkIfAnyAvailableTopicsForToday(level: level) ? .black : .brown
        default:
            return .gray
        }
    }
    
    func setStrokeColor(for level: Level) -> Color {
        let currentDay = getCurrentDayOfWeek()

        switch level.level {
        case 1:
            return .black // Level 1 has black text every day
        case 2:
            return (currentDay == "Tuesday" || currentDay == "Thursday") ? .black : .brown
        case 3:
            return currentDay == "Friday" ? .black : .brown
        case 4, 5:
            return currentDay == "Friday" && topicStudyViewModel.checkIfAnyAvailableTopicsForToday(level: level) ? .black : .brown
        default:
            return .gray
        }
    }


    /// Helper function to get the current day of the week
    func getCurrentDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date())
    }
    
    /// Formats the current date
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: Date())
    }
}
