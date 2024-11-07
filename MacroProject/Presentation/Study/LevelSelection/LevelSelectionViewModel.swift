
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
    @Published var showStudyConfirmation: Bool = false
    
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
                    print("\(phrases)\n")
                    let phraseHasDoneToday = phrases.filter {
                        let isLastReviewedToday = $0.lastReviewedDate.map { Calendar.current.isDate($0, inSameDayAs: self.today) } ?? false
                        return ($0.prevLevel == String(selectedLevel.level) && isLastReviewedToday)
                    }.count
                    let phraseShouldBeDoneToday = phrases.count
                    return TopicDTO(
                        id: topic.id,
                        name: topic.name,
                        description: topic.desc,
                        icon: topic.icon,
                        hasReviewedTodayCount: phraseHasDoneToday,
                        phraseCardCount: phraseShouldBeDoneToday,
                        isDisabled: phraseHasDoneToday == phraseShouldBeDoneToday,
                        phraseCards: phrases
                    )
                } ?? []
                
                self.topicsToReviewToday = topicDTOs
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
