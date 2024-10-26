//import Foundation
//import Combine
//
//final class TopicStudyViewModel: ObservableObject {
//    @Published var topicsToReviewTodayFilteredByLevel: [TopicDTO] = []
//    @Published var availableTopicsToReview: [TopicDTO] = []
//    @Published var unavailableTopicsToReview: [TopicDTO] = []
//    @Published var selectedTopicToReview: TopicDTO = TopicDTO(id: "", name: "", description: "", icon: "", hasReviewedTodayCount: 0, phraseCardCount: 0, phraseCards: [])
//    @Published var showUnavailableAlert: Bool = false
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    
//    private let topicUseCase: TopicUseCase = TopicUseCase()
//    private let phraseCardUseCase: PhraseCardUseCase = PhraseCardUseCase()
//    private var cancellables = Set<AnyCancellable>()
//    private let phraseStudyViewModel: PhraseStudyViewModel = PhraseStudyViewModel()
//    private let levelStudyViewModel: LevelViewModel = LevelViewModel()
//    
//    func fetchAvailableTopicsToReview() {
//        let today = Calendar.current.startOfDay(for: Date())
//        
//        availableTopicsToReview = topicsToReviewTodayFilteredByLevel.compactMap { topic in
//            if topic.phraseCards.contains(where: { phraseCard in
//                guard let nextReviewDate = phraseCard.nextReviewDate else { return false }
//                return Calendar.current.isDate(nextReviewDate, inSameDayAs: today)
//            }) {
//                return topic
//            }
//            return nil
//        }
//    }
//
//    func fetchUnavailableTopicsToReview() {
//        let today = Calendar.current.startOfDay(for: Date())
//        
//        unavailableTopicsToReview = topicsToReviewTodayFilteredByLevel.compactMap { topic in
//            if topic.phraseCards.contains(where: { phraseCard in
//                guard let nextReviewDate = phraseCard.nextReviewDate,
//                      let lastReviewedDate = phraseCard.lastReviewedDate else { return false }
//                return Calendar.current.isDate(lastReviewedDate, inSameDayAs: today)
//            }) {
//                return topic
//            }
//            return nil
//        }
//    }
//    
//    func checkIfAnyAvailableTopicsForToday(level: Level) -> Bool {
//        let today = Calendar.current.startOfDay(for: Date())
//        let day = getCurrentDayOfWeek()
//
//        if level.level == 4 {
//            for topic in topicsToReviewTodayFilteredByLevel {
//                if topic.phraseCards.contains(where: { phraseCard in
//                    guard let lastReviewedDate = phraseCard.lastReviewedDate else { return false }
//                    let twoWeeksAgo = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: today)!
//                    return lastReviewedDate == twoWeeksAgo
//                }) {
//                    return true
//                }
//            }
//        }
//
//        if level.level == 5 {
//            for topic in topicsToReviewTodayFilteredByLevel {
//                if topic.phraseCards.contains(where: { phraseCard in
//                    guard let lastReviewedDate = phraseCard.lastReviewedDate else { return false }
//                    let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: today)!
//                    return lastReviewedDate == oneMonthAgo
//                }) {
//                    return true
//                }
//            }
//        }
//
//        return false
//    }
//    
//    func checkIfTopicsEmpty(for level: Level) {
//        let currentDay = getCurrentDayOfWeek()
//        
//        // Check if both available and unavailable topics are empty
//        if topicsToReviewTodayFilteredByLevel.isEmpty {
//            switch level.level {
//            case 2:
//                if (currentDay == "Tuesday" && currentDay == "Thursday"){
//                    levelStudyViewModel.showAlert = true
//                    levelStudyViewModel.alertTitle = "No Cards to Review yet"
//                    levelStudyViewModel.alertMessage = "No answers have passed level 1 yet"
//                }
//                
//            case 3:
//                if (currentDay == "Friday"){
//                    levelStudyViewModel.showAlert = true
//                    levelStudyViewModel.alertTitle = "No Cards to Review Yet"
//                    levelStudyViewModel.alertMessage = "No answers have passed level 3 yet"
//                }
//            case 4,5:
//                if (currentDay == "Friday" && !checkIfAnyAvailableTopicsForToday(level: level)){
//                    levelStudyViewModel.showAlert = true
//                    levelStudyViewModel.alertTitle = "No Cards to Review Yet"
//                    levelStudyViewModel.alertMessage = "No answers have passed level \(level.level) yet"
//                }
//            default:
//                break
//            }
//        }
//    }
//    
//    func fetchTopicsByFilteredPhraseCards(levelNumber: String, level: Level) {
//        guard !isLoading else { return }
//        
//        isLoading = true
//        
//        // Step 1: Fetch PhraseCards
//        phraseCardUseCase.fetchByLevel(levelNumber: levelNumber)
//            .receive(on: DispatchQueue.main)
//            .flatMap { [weak self] phraseCards -> AnyPublisher<[TopicModel]?, NetworkError> in
//                guard let self = self else { return Just(nil).setFailureType(to: NetworkError.self).eraseToAnyPublisher() }
//                
//                self.phraseStudyViewModel.phraseCardsByLevel = phraseCards ?? []
//                let uniqueTopicIDs = self.extractUniqueTopicIDs(from: phraseCards)
//                
//                // Step 2: Fetch Topics by IDs
//                return self.topicUseCase.fetchTopicsByIds(ids: uniqueTopicIDs)
//            }
//            .sink { [weak self] completion in
//                self?.isLoading = false
//                if case let .failure(error) = completion {
//                    self?.errorMessage = error.localizedDescription
//                }
//            } receiveValue: { [weak self] topics in
//                self?.processTopics(topics, for: level)
//            }
//            .store(in: &cancellables)
//    }
//
//    private func extractUniqueTopicIDs(from phraseCards: [PhraseCardModel]?) -> [String] {
//        let topicIDs = phraseCards?.compactMap { $0.topicID } ?? []
//        return Array(Set(topicIDs))  // Ensures uniqueness
//    }
//
//    private func processTopics(_ topics: [TopicModel]?, for level: Level) {
//        let today = Calendar.current.startOfDay(for: Date())
//        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
//        
//        self.topicsToReviewTodayFilteredByLevel = topics?.compactMap { topic in
//            let filteredPhraseCards = self.phraseStudyViewModel.phraseCardsByLevel.filter { $0.topicID == topic.id }
//            guard !filteredPhraseCards.isEmpty else { return nil }
//            
//            let hasReviewedTodayCount = filteredPhraseCards.filter {
//                Calendar.current.isDate($0.lastReviewedDate ?? yesterday, inSameDayAs: today)
//            }.count
//            
//            return TopicDTO(
//                id: topic.id,
//                name: topic.name,
//                description: topic.desc,
//                icon: topic.icon,
//                hasReviewedTodayCount: hasReviewedTodayCount,
//                phraseCardCount: filteredPhraseCards.count,
//                phraseCards: filteredPhraseCards
//            )
//        } ?? []
//        
//        // Trigger further operations
//        fetchAvailableTopicsToReview()
//        fetchUnavailableTopicsToReview()
//        checkIfTopicsEmpty(for: level)
//    }
//
//    
//    func resetUnavailableAlert() {
//        showUnavailableAlert = false
//    }
//    
//    /// Helper function to get the current day of the week
//    func getCurrentDayOfWeek() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEEE"
//        return dateFormatter.string(from: Date())
//    }
//    
//}
