//
//  LevelSelectionViewModel.swift
//  MacroProject
//
//  Created by Agfi on 29/10/24.
//

import Foundation
import Combine

final class LevelSelectionViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var selectedLevel: Level?
    @Published var selectedTopicToReview: TopicDTO = TopicDTO(id: "", name: "", description: "", icon: "", hasReviewedTodayCount: 0, phraseCardCount: 0, phraseCards: [])
    
    @Published var availableTopicsToReview: [TopicDTO] = []
    @Published var unavailableTopicsToReview: [TopicDTO] = []
    @Published var availablePhrasesToReview: [PhraseCardModel] = []
    
    @Published var showUnavailableAlert: Bool = false
    @Published var showAlert: Bool = false
    @Published var showStudyConfirmation: Bool = false
    
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    private var today: Date = Calendar.current.startOfDay(for: Date())
    private var phraseCardUseCase: PhraseCardUseCaseType
    private var topicUseCase: TopicUseCaseType
    
    init(phraseCardUseCase: PhraseCardUseCaseType = PhraseCardUseCase(), topicUseCase: TopicUseCaseType = TopicUseCase()) {
        self.phraseCardUseCase = phraseCardUseCase
        self.topicUseCase = topicUseCase
    }
    
    func fetchAvailablePhrasesToReview(levelNumber: String) {
        guard !isLoading else { return }
        isLoading = true
        
        var availableTopicsID: [String] = []
        
        phraseCardUseCase.fetchByLevelAndDate(levelNumber: levelNumber, Date: today, dateType: .nextDate)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] phrases in
                guard let self = self else { return }
                
                self.availablePhrasesToReview = phrases ?? []
                let topicIDs = Set(phrases?.compactMap { $0.topicID } ?? [])
                availableTopicsID = Array(topicIDs)
                fetchAvailableTopicsByIds(topicIDs: availableTopicsID)
            }
            .store(in: &cancellables)
    }
    
    func fetchAvailableTopicsByIds(topicIDs: [String]) {
        topicUseCase.fetchTopicsByIds(ids: topicIDs)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] topics in
                let phrasesByTopic = Dictionary(grouping: self?.availablePhrasesToReview ?? []) { $0.topicID }
                let topicDTOs: [TopicDTO] = topics?.compactMap { topic in
                    let phrases = phrasesByTopic[topic.id] ?? []
                    let hasReviewedTodayCount = phrases.filter { $0.lastReviewedDate == self?.today }.count
                    return TopicDTO(id: topic.id, name: topic.name, description: topic.desc, icon: topic.icon, hasReviewedTodayCount: hasReviewedTodayCount, phraseCardCount: phrases.count, phraseCards: phrases)
                } ?? []
                
                self?.availableTopicsToReview = topicDTOs
            }
            .store(in: &cancellables)
    }
    
    func getCurrentDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date())
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
}
