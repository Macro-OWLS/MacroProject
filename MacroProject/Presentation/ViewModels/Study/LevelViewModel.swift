
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
    @Published var availableTopicsToReview: [TopicDTO] = []
    @Published var unavailableTopicsToReview: [TopicDTO] = []
    @Published var availableTopicsID: [String] = []
    @Published var unavailableTopicsID: [String] = []
    @Published var availablePhrasesToReview: [PhraseCardModel] = []
    @Published var unavailablePhrasesToReview: [PhraseCardModel] = []
    
    @Published var showUnavailableAlert: Bool = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showAlert: Bool = false
    @Published var showStudyConfirmation: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    @Published var currIndex: Int
    @Published var isRevealed: Bool
    @Published var userInput: String
    @Published var recapAnsweredPhraseCards: [UserAnswerDTO]
    @Published var answeredCardIndices: Set<Int> = []
    @Published var isAnswerIndicatorVisible: Bool = false
    @Published var unansweredPhrasesCount: Int = 0
    
    @Published var selectedTopicToReview: TopicDTO = TopicDTO(id: "", name: "", description: "", icon: "", hasReviewedTodayCount: 0, phraseCardCount: 0, phraseCards: [])
    @Published var selectedLevel: Level = .init(level: 0, title: "", description: "")
    @Published var levels: [Level] = [
        .init(level: 1, title: "Level 1", description: "Learn this everyday"),
        .init(level: 2, title: "Level 2", description: "Learn this every Tuesday & Thursday"),
        .init(level: 3, title: "Level 3", description: "Learn this every Friday"),
        .init(level: 4, title: "Level 4", description: "Learn this biweekly on Friday"),
        .init(level: 5, title: "Level 5", description: "Learn this once a month")
    ]
    
    private let topicUseCase: TopicUseCase = TopicUseCase()
    private let phraseCardUseCase: PhraseCardUseCase = PhraseCardUseCase()
    private var cancellables = Set<AnyCancellable>()
    
    var phrasesByTopicSelected: [PhraseCardModel] {
        availablePhrasesToReview.filter { $0.topicID == selectedTopicToReview.id }
    }

    init(currIndex: Int = 0) {
        self.currIndex = currIndex
        self.isRevealed = false
        self.userInput = ""
        self.recapAnsweredPhraseCards = []
    }
    
    func updateUnansweredPhrasesCount() {
        unansweredPhrasesCount = phrasesByTopicSelected.filter { phrase in
            !recapAnsweredPhraseCards.contains { $0.id == phrase.id }
        }.count
    }
    
    func checkIfAnyAvailableTopicsForToday(level: Level) -> Bool {
        let today = Calendar.current.startOfDay(for: Date())
        let day = getCurrentDayOfWeek()

        if level.level == 4 {
            for topic in availableTopicsToReview {
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
            for topic in availableTopicsToReview {
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
    
    func fetchTodayPhrases(level: String) {
        let today = Calendar.current.startOfDay(for: Date())
        guard !isLoading else { return }
        isLoading = true
        print("Fetching phrases to review for level \(level)...")
        
        fetchAvailablePhrasesToReview(today: today, levelNumber: level)
        fetchUnavailablePhrasesToReview(today: today, levelNumber: level)
    }

    func fetchAvailableTopicsToReview() {
        topicUseCase.fetchTopicsByIds(ids: availableTopicsID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Failed to fetch available topics: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] topics in
                guard let topics = topics else { return }
                let today = Calendar.current.startOfDay(for: Date())
                let phrasesByTopic = Dictionary(grouping: self?.availablePhrasesToReview ?? []) { $0.topicID }
                let topicDTOs: [TopicDTO] = topics.compactMap { topic in
                    let phrases = phrasesByTopic[topic.id] ?? []
                    let hasReviewedTodayCount = phrases.filter { $0.lastReviewedDate == today }.count
                    let phraseCount = phrases.count
                    return TopicDTO(
                        id: topic.id,
                        name: topic.name,
                        description: topic.desc,
                        icon: topic.icon,
                        hasReviewedTodayCount: hasReviewedTodayCount,
                        phraseCardCount: phraseCount,
                        phraseCards: phrases
                    )
                }
                self?.availableTopicsToReview = topicDTOs
                print("Total available topics to review: \(self?.availableTopicsToReview.count ?? 0)")
            }
            .store(in: &cancellables)
    }

    func fetchUnavailableTopicsToReview() {
        topicUseCase.fetchTopicsByIds(ids: unavailableTopicsID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Failed to fetch unavailable topics: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] topics in
                guard let topics = topics ?? [] as? [TopicModel] else { return }
                let today = Calendar.current.startOfDay(for: Date())
                let phrasesByTopic = Dictionary(grouping: self?.unavailablePhrasesToReview ?? []) { $0.topicID }
                let topicDTOs: [TopicDTO] = topics.compactMap { topic in
                    let phrases = phrasesByTopic[topic.id] ?? []
                    let hasReviewedTodayCount = phrases.filter { $0.lastReviewedDate == today }.count
                    let phraseCount = phrases.count
                    return TopicDTO(
                        id: topic.id,
                        name: topic.name,
                        description: topic.desc,
                        icon: topic.icon,
                        hasReviewedTodayCount: hasReviewedTodayCount,
                        phraseCardCount: phraseCount,
                        phraseCards: phrases
                    )
                }
                self?.unavailableTopicsToReview = topicDTOs
                print("Total unavailable topics to review: \(self?.unavailableTopicsToReview.count ?? 0)")
            }
            .store(in: &cancellables)
    }

    func fetchAvailablePhrasesToReview(today: Date, levelNumber: String) {
        phraseCardUseCase.fetchByLevelAndDate(levelNumber: levelNumber, Date: today, dateType: .nextDate)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Failed to fetch available phrases: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] availablePhrase in
                self?.availablePhrasesToReview = availablePhrase ?? []
                let topicIDs = Set(availablePhrase?.compactMap { $0.topicID } ?? [])
                self?.availableTopicsID = Array(topicIDs)
                self?.fetchAvailableTopicsToReview()
                print("Total available phrases to review: \(self?.availablePhrasesToReview.count ?? 0)")
            }
            .store(in: &cancellables)
    }

    func fetchUnavailablePhrasesToReview(today: Date, levelNumber: String) {
        phraseCardUseCase.fetchByLevelAndDate(levelNumber: levelNumber, Date: today, dateType: .lastDate)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Failed to fetch unavailable phrases: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] unavailablePhrase in
                self?.unavailablePhrasesToReview = unavailablePhrase ?? []
                let topicIDs = Set(unavailablePhrase?.compactMap { $0.topicID } ?? [])
                self?.unavailableTopicsID = Array(topicIDs)
                self?.fetchUnavailableTopicsToReview()
                print("Total unavailable phrases to review: \(self?.unavailablePhrasesToReview.count ?? 0)")
            }
            .store(in: &cancellables)
    }


    
    func checkIfTopicsEmpty(for level: Level) {
        let currentDay = getCurrentDayOfWeek()
        
        if availableTopicsToReview.isEmpty {
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
    
    func addUserAnswer(userAnswer: UserAnswerDTO) {
        recapAnsweredPhraseCards.append(userAnswer)
        answeredCardIndices.insert(currIndex)
        isAnswerIndicatorVisible = true
        unansweredPhrasesCount -= 1
    }

    func moveToNextCard(phraseCards: [PhraseCardModel]) {
        guard !phraseCards.isEmpty else { return }

        isAnswerIndicatorVisible = false
        var newIndex = currIndex + 1

        newIndex = newIndex % phraseCards.count
        while answeredCardIndices.contains(newIndex) {
            newIndex = (newIndex + 1) % phraseCards.count
        }

        currIndex = newIndex
    }

    func moveToPreviousCard() {
        guard currIndex > 0 else { return }

        var newIndex = currIndex
        while newIndex >= 0 && answeredCardIndices.contains(newIndex) {
            newIndex -= 1
        }
        if newIndex >= 0 {
            currIndex = newIndex
        }
    }

    func getOffset(for index: Int) -> CGFloat {
        if index == currIndex {
            return 0
        } else if index < currIndex {
            return -50
        } else {
            return 50
        }
    }
}
