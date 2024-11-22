
import Foundation
import Combine

final class LevelSelectionViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var selectedLevel: Level = Level(level: 0, title: "", description: "")
    @Published var phrasesToReviewToday: [PhraseCardModel] = []
    @Published var topicsToReviewToday: [TopicDTO] = []
    
    @Published var showUnavailableAlert: Bool = false
    @Published var showAlert: Bool = false
    @Published var showReviewConfirmation: Bool = false
    
    @Published var isLevelEmpty: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    private var cancellables: Set<AnyCancellable> = []
    private var today: Date = Calendar.current.startOfDay(for: Date())
    private var phraseCardUseCase: PhraseCardUseCaseType
    private var reviewedPhraseUseCase: ReviewedPhraseUseCaseType
    private var topicUseCase: TopicUseCaseType
    
    init(phraseCardUseCase: PhraseCardUseCaseType = PhraseCardUseCase(), topicUseCase: TopicUseCaseType = TopicUseCase(), reviewedPhraseUseCase: ReviewedPhraseUseCaseType = ReviewedPhraseUseCase()) {
        self.phraseCardUseCase = phraseCardUseCase
        self.topicUseCase = topicUseCase
        self.reviewedPhraseUseCase = reviewedPhraseUseCase
    }
    
    func fetchPhrasesToReviewTodayFilteredByLevel(selectedLevel level: Level) {
        guard !isLoading else { return }
        isLoading = true
        
        var availableTopicsID: [String] = []
        
        phraseCardUseCase.fetchByLevel(levelNumber: String(level.level))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] phrases in
                guard let self = self else { return }
                
                // Filter phrases based on nextReviewDate or lastReviewedDate matching today
                self.phrasesToReviewToday = phrases?.filter {
                    let isNextReviewToday = $0.nextReviewDate.map { Calendar.current.isDate($0, inSameDayAs: self.today) } ?? false
                    let isLastReviewedToday = $0.lastReviewedDate.map { Calendar.current.isDate($0, inSameDayAs: self.today) } ?? false
                    return (isNextReviewToday || isLastReviewedToday) &&
                    ($0.prevLevel == String(level.level) || $0.nextLevel == String(level.level))
                } ?? []
                
                let topicIDs = Set(self.phrasesToReviewToday.compactMap { $0.topicID })
                availableTopicsID = Array(topicIDs)
                print(topicIDs)
                
                self.fetchAvailableTopicsByIds(topicIDs: availableTopicsID, selectedLevel: level)
                
            }
            .store(in: &cancellables)
    }
    
    func fetchAvailableTopicsByIds(topicIDs: [String], selectedLevel: Level) {
        topicUseCase.fetchTopicsByIds(ids: topicIDs)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] topics in
                guard let self = self else { return }
                
                let phrasesByTopic = Dictionary(grouping: self.phrasesToReviewToday) { $0.topicID }
                
                let topicDTOs: [TopicDTO] = topics?.compactMap { topic in
                    let phrases = phrasesByTopic[topic.id] ?? []
                    
                    // Calculate `phraseHasDoneToday`
                    let phraseHasDoneToday = self.calculatePhraseHasDoneToday(
                        phrases: phrases,
                        selectedLevel: selectedLevel
                    )
                    
                    // Calculate `phraseShouldBeDoneToday`
                    let phraseShouldBeDoneToday = self.calculatePhraseShouldBeDoneToday(
                        phrases: phrases,
                        selectedLevel: selectedLevel
                    )
                    
                    let phraseCardCount = phraseShouldBeDoneToday.count == 0
                        ? phraseHasDoneToday
                        : phraseShouldBeDoneToday.count + phraseHasDoneToday
                    
                    let phraseCardCountNextLevel = self.calculatePhraseCardCountNextLevel(
                        phrases: phrases,
                        selectedLevel: selectedLevel
                    )
                    
                    let adjustedPhraseCardCount = phraseCardCount == 0
                        ? phraseCardCountNextLevel
                        : phraseCardCount
                    
                    return TopicDTO(
                        id: topic.id,
                        name: topic.name,
                        description: topic.desc,
                        icon: topic.icon,
                        hasReviewedTodayCount: phraseHasDoneToday,
                        phraseCardCount: adjustedPhraseCardCount,
                        isDisabled: phraseHasDoneToday == phraseCardCount,
                        phraseCards: phrases
                    )
                } ?? []
                
                self.topicsToReviewToday = topicDTOs
                self.isLevelEmpty = topicsToReviewToday.isEmpty
            }
            .store(in: &cancellables)
    }

    // Helper functions for calculations

    private func calculatePhraseHasDoneToday(phrases: [PhraseCardModel], selectedLevel: Level) -> Int {
        phrases.filter { phrase in
            guard let lastReviewedDate = phrase.lastReviewedDate else { return false }
            return phrase.prevLevel == String(selectedLevel.level) &&
                   Calendar.current.isDate(lastReviewedDate, inSameDayAs: today)
        }.count
    }

    private func calculatePhraseShouldBeDoneToday(phrases: [PhraseCardModel], selectedLevel: Level) -> [PhraseCardModel] {
        phrases.filter { phrase in
            guard let nextReviewDate = phrase.nextReviewDate else { return false }
            return phrase.nextLevel == String(selectedLevel.level) &&
                   Calendar.current.isDate(nextReviewDate, inSameDayAs: today)
        }
    }

    private func calculatePhraseCardCountNextLevel(phrases: [PhraseCardModel], selectedLevel: Level) -> Int {
        phrases.filter { phrase in
            guard let lastReviewedDate = phrase.lastReviewedDate else { return false }
            return phrase.nextLevel == String(selectedLevel.level) &&
                   Calendar.current.isDate(lastReviewedDate, inSameDayAs: today)
        }.count
    }

    
    func getCurrentDayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date())
    }
    
    func checkForAlerts(level: Level){
        let currentDay = getCurrentDayOfWeek()
        
        switch level.level {
        case 2:
            if (currentDay != "Tuesday" && currentDay != "Thursday") {
                alertTitle = "Not Available Yet"
                alertMessage = "You can only access this on Tuesday & Thursday"
                showAlert = true
            }
        case 3, 4, 5:
            if (currentDay != "Friday") {
                alertTitle = "Not Available Yet"
                alertMessage = "You can only access this on Friday"
                showAlert = true
            }
        default:
            showAlert = false
        }
    
    }
    
    func emptyAlerts(level: Level) {
        if isLevelEmpty && !showAlert {
            switch level.level {
            case 2:
                alertTitle = "No Cards Yet"
                alertMessage = "No answers have passed level 1 yet"
                showAlert = true
            case 3:
                alertTitle = "No Cards Yet"
                alertMessage = "No answers have passed level 2 yet"
                showAlert = true
            case 4:
                alertTitle = "No Cards Yet"
                alertMessage = "Access requires cards to be here for 2 weeks"
                showAlert = true
            case 5:
                alertTitle = "No Cards Yet"
                alertMessage = "Access requires cards to be here for a month"
                showAlert = true
            default:
                showAlert = false
            }
        }
    }
}
