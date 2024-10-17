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
    @Published var topicsToReviewTodayFilteredByLevel: [TopicDTO] = []
    @Published var phraseCardsByLevel: [PhraseCardModel] = []
    @Published var selectedPhraseCardsToReviewByTopic: [PhraseCardModel] = []
    @Published var dueTodayPhraseCards: [PhraseCardModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var showStudyConfirmation: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var selectedTopicToReview: TopicDTO = TopicDTO(id: "", name: "", description: "", hasReviewedTodayCount: 0, phraseCardCount: 0, phraseCards: [])
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
    
//    func fetchDueTodayPhraseCards(topicID: String, levelNumber: String) {
//        isLoading = true
//        
//        phraseCardUseCase.fetchByLevelAndId(topicID: topicID, levelNumber: levelNumber)
//            .sink { [weak self] completion in
//                self?.isLoading = false
//                if case .failure(let error) = completion {
//                    self?.errorMessage = error.localizedDescription
//                }
//            } receiveValue: { [weak self] phraseCards in
//                guard let phraseCards = phraseCards else { return }
//                let today = Calendar.current.startOfDay(for: Date())
//                self?.dueTodayPhraseCards = phraseCards.filter {
//                    guard let nextReviewDate = $0.nextReviewDate else { return false }
//                    return Calendar.current.isDate(nextReviewDate, inSameDayAs: today)
//                }
//            }
//            .store(in: &cancellables)
//    }
//
//    
//    func filterTopicsWithPhraseCardsDueToday() {
//        let today = Calendar.current.startOfDay(for: Date())
//        
//        self.topicsToReviewTodayFilteredByLevel = self.topicsToReviewTodayFilteredByLevel.filter { topic in
//            // Filter phrase cards due today
//            let phraseCardsDueToday = topic.phraseCards.filter {
//                guard let nextReviewDate = $0.nextReviewDate else { return false }
//                return Calendar.current.isDate(nextReviewDate, inSameDayAs: today)
//            }
//            // Return topics that have any phrase card due today
//            return !phraseCardsDueToday.isEmpty
//        }
//    }


    func checkIfAnyPhraseCardNotDueToday(level: Level) {
        let today = Calendar.current.startOfDay(for: Date())
        
        for topic in topicsToReviewTodayFilteredByLevel {
            let phrasesNotDueToday = selectedPhraseCardsToReviewByTopic.filter {
                $0.topicID == topic.id && !Calendar.current.isDate($0.nextReviewDate ?? Date(), inSameDayAs: today)
            }
            
            if !phrasesNotDueToday.isEmpty {
                showAlert = true
                alertTitle = "Not Available Yet"
                
                // Adjust the alert message based on the level
                switch level.level {
                case 4:
                    alertMessage = "Access requires cards to be here for 2 weeks."
                case 5:
                    alertMessage = "Access requires cards to be here for a month."
                default:
                    alertMessage = ""
                }
                
                break
            }
        }
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
        case 3:
            if (currentDay != "Friday") {
                showAlert = true
                alertTitle = "Not Available Yet"
                alertMessage = "You can only access this on Friday"
            }
        case 4:
            if (currentDay != "Friday") {
                checkIfAnyPhraseCardNotDueToday(level: level)
            }
        case 5:
            if (currentDay != "Friday") {
                checkIfAnyPhraseCardNotDueToday(level: level)
            }
        default:
            showAlert = false
        }
    }
    
    
    
    // Checks if topics are empty and sets the alert information
    func checkIfTopicsEmpty(level: Level) {
        if level.level > 1 && topicsToReviewTodayFilteredByLevel.isEmpty {
            showAlert = true
            switch level.level {
            case 2:
                alertTitle = "No Cards to Review yet"
                alertMessage = "No answers have passed level 1 yet"
            case 3:
                alertTitle = "No Cards Yet"
                alertMessage = "No answers have passed level 2 yet"
            case 4:
                alertTitle = "No Cards Yet"
                alertMessage = "No answers have passed level 3 yet"
            case 5:
                alertTitle = "No Cards Yet"
                alertMessage = "No answers have passed level 4 yet"
            default:
                break
            }
        }
    }

    // Resets the alert state when user clicks OK
    func resetAlert() {
        showAlert = false
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
                    let phraseCount = self?.phraseCardsByLevel.filter { $0.topicID == topic.id }.count ?? 0
                    let hasReviewedTodayCount = self?.phraseCardsByLevel.filter {
                        $0.topicID == topic.id && Calendar.current.isDate($0.lastReviewedDate ?? Date(), inSameDayAs: today)
                    }.count ?? 0
                    return TopicDTO(
                        id: topic.id,
                        name: topic.name,
                        description: topic.desc,
                        hasReviewedTodayCount: hasReviewedTodayCount,
                        phraseCardCount: phraseCount,
                        phraseCards: []
                    )
                } ?? []

                self?.checkIfTopicsEmpty(level: level)
            }
            .store(in: &cancellables)
    }

    /// Returns the appropriate background color based on the level and current day
    func setBackgroundColor(for level: Level) -> Color {
        let currentDay = getCurrentDayOfWeek()

        switch level.level {
        case 1:
            return .cream // Level 1 has background cream every day
        case 2:
            return (currentDay == "Tuesday" || currentDay == "Thursday") ? .cream : .cream
        case 3, 4, 5:
            return currentDay == "Friday" ? .cream : .cream
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
            return (currentDay == "Tuesday" || currentDay == "Thursday") ? .black : .gray
        case 3, 4, 5:
            return currentDay == "Friday" ? .black : .gray
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
        dateFormatter.dateFormat = "EEEE, d MMM yyyy"
        return dateFormatter.string(from: Date())
    }
}
