//
//  LevelViewModel.swift
//  MacroProject
//
//  Created by Agfi on 13/10/24.
//

import Foundation
import SwiftUI
import Combine

import Foundation

internal struct TopicDTO: Equatable, Identifiable, Decodable, Hashable {
    var id: String
    var name: String
    var description: String
    var icon: String
    var hasReviewedTodayCount: Int
    var phraseCardCount: Int
    var phraseCards: [PhraseCardModel]
}

final class LevelViewModel: ObservableObject {
    @Published var topicsToReviewTodayFilteredByLevel: [TopicDTO] = []
    @Published var phraseCardsByLevel: [PhraseCardModel] = []
    @Published var selectedPhraseCardsToReviewByTopic: [PhraseCardModel] = []
    @Published var dueTodayPhraseCards: [PhraseCardModel] = []
    
    @Published var availableTopicsToReview: [TopicDTO] = []
    @Published var unavailableTopicsToReview: [TopicDTO] = []
    @Published var showUnavailableAlert: Bool = false
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var showStudyConfirmation: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var selectedTopicToReview: TopicDTO = TopicDTO(id: "", name: "", description: "", icon: "", hasReviewedTodayCount: 0, phraseCardCount: 0, phraseCards: [])
    @Published var selectedLevel: Level = .init(level: 0, title: "", description: "")
    
    private let topicUseCase: TopicUseCase = TopicUseCase(repository: TopicRepository())
    private let phraseCardUseCase: PhraseCardUseCase = PhraseCardUseCase(repository: PhraseCardRepository())
    private var cancellables = Set<AnyCancellable>()
    
    @Published var levels: [Level] = [
        .init(level: 1, title: "Level 1", description: "Learn this everyday"),
        .init(level: 2, title: "Level 2", description: "Learn this every Tuesday & Thursday"),
        .init(level: 3, title: "Level 3", description: "Learn this every Friday"),
        .init(level: 4, title: "Level 4", description: "Learn this biweekly on Friday"),
        .init(level: 5, title: "Level 5", description: "Learn this once a month")
    ]
    
    
    
    func checkIfAnyAvailableTopicsForToday(level: Level) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let day = getCurrentDayOfWeek()

        if level.level == 4 {
            for topic in topicsToReviewTodayFilteredByLevel {
                if topic.phraseCards.contains(where: { phraseCard in
                    guard let lastReviewedDate = phraseCard.lastReviewedDate else { return false }
                    let twoWeeksAgo = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: today)!
                    return lastReviewedDate == twoWeeksAgo
                }) {
                    return true
                }
            }
        }

        if level.level == 5 {
            for topic in topicsToReviewTodayFilteredByLevel {
                if topic.phraseCards.contains(where: { phraseCard in
                    guard let lastReviewedDate = phraseCard.lastReviewedDate else { return false }
                    let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: today)!
                    return lastReviewedDate == oneMonthAgo
                }) {
                    return true
                }
            }
        }

        return false
    }

    
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
    
    func printReviewDates(topic: TopicDTO) {
        for phrase in topic.phraseCards {
            print("Last Reviewed Date: \(String(describing: phrase.lastReviewedDate))")
            print("Next Review Date: \(String(describing: phrase.nextReviewDate))")
        }
    }

    
    func getAvailableTopicsToReview() {
        let today = Calendar.current.startOfDay(for: Date())
        
        availableTopicsToReview = topicsToReviewTodayFilteredByLevel.compactMap { topic in
            // Check if there are any phrase cards in the topic that are available for review today
            if topic.phraseCards.contains(where: { phraseCard in
                // Safely unwrap nextReviewDate and lastReviewedDate
                guard let nextReviewDate = phraseCard.nextReviewDate else {
                    return false // Skip if nextReviewDate is nil
                }
                
                // Unwrap lastReviewedDate safely for the comparison
                if let lastReviewedDate = phraseCard.lastReviewedDate {
                    // Ensure the next review date is today, and it hasn't been reviewed today
                    return Calendar.current.isDate(nextReviewDate, inSameDayAs: today)
                } else {
                    // If lastReviewedDate is nil, treat it as not reviewed
                    return Calendar.current.isDate(nextReviewDate, inSameDayAs: today)
                }
            }) {
                return topic // Return the topic if it has available phrase cards
            }
            return nil // Return nil if no available phrase cards are found
        }
        
        print("Total available topics: \(availableTopicsToReview.count)")
    }

    func getUnavailableTopicsToReview() {
        let today = Calendar.current.startOfDay(for: Date())
        
        unavailableTopicsToReview = topicsToReviewTodayFilteredByLevel.compactMap { topic in
            // Check if there are any phrase cards in the topic that are unavailable for review today
            if topic.phraseCards.contains(where: { phraseCard in
                // Safely unwrap nextReviewDate and lastReviewedDate
                guard let nextReviewDate = phraseCard.nextReviewDate,
                      let lastReviewedDate = phraseCard.lastReviewedDate else {
                    return false // Skip if either date is nil
                }
                
                // Ensure the next review date is today and it has been reviewed today
                return Calendar.current.isDate(lastReviewedDate, inSameDayAs: today)
            }) {
                return topic // Return the topic if it has unavailable phrase cards
            }
            return nil // Return nil if no unavailable phrase cards are found
        }
        
        print("Total unavailable topics: \(unavailableTopicsToReview.count)")
    }
    
    func checkIfTopicsEmpty(for level: Level) {
        let currentDay = getCurrentDayOfWeek()
        
        // Check if both available and unavailable topics are empty
        if topicsToReviewTodayFilteredByLevel.isEmpty {
            switch level.level {
            case 2:
                if (currentDay == "Tuesday" && currentDay == "Thursday"){
                    showAlert = true
                    alertTitle = "No Cards to Review yet"
                    alertMessage = "No answers have passed level 1 yet"
                }
                
            case 3:
                if (currentDay == "Friday"){
                    showAlert = true
                    alertTitle = "No Cards to Review Yet"
                    alertMessage = "No answers have passed level 3 yet"
                }
            case 4,5:
                if (currentDay == "Friday" && !checkIfAnyAvailableTopicsForToday(level: level)){
                    showAlert = true
                    alertTitle = "No Cards to Review Yet"
                    alertMessage = "No answers have passed level \(level.level) yet"
                }
            default:
                break
            }
        }
    }
    
    // Resets the alert state when user clicks OK
    func resetAlert() {
        showAlert = false
    }
    
    func resetUnavailableAlert() {
        showUnavailableAlert = false
    }
    
    func setSelectedLevel(level: Level) {
        selectedLevel = level
    }
    
    func fetchPhraseCardsToReviewByTopic(levelNumber: String, topicID: String) {
        guard !isLoading else { return }
        
        isLoading = true
        
        phraseCardUseCase.fetchByLevel(levelNumber: levelNumber)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] phraseCards in
                self?.selectedPhraseCardsToReviewByTopic = phraseCards?.filter { $0.topicID == topicID } ?? []
            }
            .store(in: &cancellables)
    }
    
    func fetchPhraseCards(levelNumber: String) {
        guard !isLoading else { return }
        
        isLoading = true
        
        phraseCardUseCase.fetchByLevel(levelNumber: levelNumber)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] phraseCards in
                self?.phraseCardsByLevel = phraseCards ?? []
            }
            .store(in: &cancellables)
    }
    
    func fetchTopicsByFilteredPhraseCards(levelNumber: String, level: Level) {
        guard !isLoading else { return }
        
        isLoading = true
        
        phraseCardUseCase.fetchByLevel(levelNumber: levelNumber)
            .receive(on: DispatchQueue.main)
            .flatMap { [weak self] phraseCards -> AnyPublisher<[TopicModel]?, NetworkError> in
                self?.phraseCardsByLevel = phraseCards ?? []
                let topicIDs = phraseCards?.compactMap { $0.topicID } ?? []
                let uniqueTopicIDs = Array(Set(topicIDs))
                return self?.topicUseCase.fetchTopicsByIds(ids: uniqueTopicIDs) ?? Just(nil).setFailureType(to: NetworkError.self).eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] topics in
                let today = Calendar.current.startOfDay(for: Date())
                self?.topicsToReviewTodayFilteredByLevel = topics?.map { topic in
                    let filteredPhraseCards = self?.phraseCardsByLevel.filter { $0.topicID == topic.id } ?? []
                    let phraseCount = filteredPhraseCards.count
                    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
                    let hasReviewedTodayCount = filteredPhraseCards.filter {
                        Calendar.current.isDate($0.lastReviewedDate ?? yesterday, inSameDayAs: today)
                    }.count
                    
                    return TopicDTO(
                        id: topic.id,
                        name: topic.name,
                        description: topic.desc,
                        icon: topic.icon,
                        hasReviewedTodayCount: hasReviewedTodayCount,
                        phraseCardCount: phraseCount,
                        phraseCards: filteredPhraseCards
                    )
                } ?? []
                
                self?.getAvailableTopicsToReview()
                self?.getUnavailableTopicsToReview()
                self?.checkIfTopicsEmpty(for: level)
            }
            .store(in: &cancellables)
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
            return currentDay == "Friday" && checkIfAnyAvailableTopicsForToday(level: level) ? .darkcream : .cream
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
            return currentDay == "Friday" && checkIfAnyAvailableTopicsForToday(level: level) ? .black : .brown
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
            return currentDay == "Friday" && checkIfAnyAvailableTopicsForToday(level: level) ? .black : .brown
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

