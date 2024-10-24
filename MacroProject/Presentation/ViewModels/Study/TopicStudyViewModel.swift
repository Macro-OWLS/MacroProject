import Foundation
import Combine

final class TopicStudyViewModel: ObservableObject {
    @Published var topicsToReviewTodayFilteredByLevel: [TopicDTO] = []
    @Published var availableTopicsToReview: [TopicDTO] = []
    @Published var unavailableTopicsToReview: [TopicDTO] = []
    @Published var selectedTopicToReview: TopicDTO = TopicDTO(id: "", name: "", description: "", icon: "", hasReviewedTodayCount: 0, phraseCardCount: 0, phraseCards: [])
    @Published var showUnavailableAlert: Bool = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let topicUseCase: TopicUseCase = TopicUseCase()
    private let phraseCardUseCase: PhraseCardUseCase = PhraseCardUseCase()
    private var cancellables = Set<AnyCancellable>()
    private let topicStudyViewModel: TopicStudyViewModel = TopicStudyViewModel()
    
    func getAvailableTopicsToReview() {
        let today = Calendar.current.startOfDay(for: Date())
        
        availableTopicsToReview = topicsToReviewTodayFilteredByLevel.compactMap { topic in
            if topic.phraseCards.contains(where: { phraseCard in
                guard let nextReviewDate = phraseCard.nextReviewDate else { return false }
                return Calendar.current.isDate(nextReviewDate, inSameDayAs: today)
            }) {
                return topic
            }
            return nil
        }
    }

    func getUnavailableTopicsToReview() {
        let today = Calendar.current.startOfDay(for: Date())
        
        unavailableTopicsToReview = topicsToReviewTodayFilteredByLevel.compactMap { topic in
            if topic.phraseCards.contains(where: { phraseCard in
                guard let nextReviewDate = phraseCard.nextReviewDate,
                      let lastReviewedDate = phraseCard.lastReviewedDate else { return false }
                return Calendar.current.isDate(lastReviewedDate, inSameDayAs: today)
            }) {
                return topic
            }
            return nil
        }
    }
    
    func fetchTopicsByFilteredPhraseCards(levelNumber: String, level: Level) {
            guard !isLoading else { return }
            
            isLoading = true
            
            phraseCardUseCase.fetchByLevel(levelNumber: levelNumber)
                .receive(on: DispatchQueue.main)
                .flatMap { [weak self] phraseCards -> AnyPublisher<[TopicModel]?, NetworkError> in
                    topicStudyViewModel.phraseCardsByLevel = phraseCards ?? []
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
    
    func resetUnavailableAlert() {
        showUnavailableAlert = false
    }
    
}
