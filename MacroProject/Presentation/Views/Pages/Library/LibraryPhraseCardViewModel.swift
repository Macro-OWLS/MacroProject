import Foundation
import Combine

final class LibraryPhraseCardViewModel: ObservableObject {
    @Published var showUnavailableAlert = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var cardsAdded: Int = 0
    private var phraseCards: [PhraseCardModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let phraseCardUseCase: PhraseCardUseCaseType
    private let router: Router
    private let phraseViewModel: PhraseCardViewModel

    init(phraseCardUseCase: PhraseCardUseCaseType, router: Router, phraseViewModel: PhraseCardViewModel) {
        self.phraseCardUseCase = phraseCardUseCase
        self.router = router
        self.phraseViewModel = phraseViewModel
    }
    
    func fetchPhraseCards(for topicID: String) {
        isLoading = true
        errorMessage = nil
        phraseViewModel.fetchPhraseCards(topicID: topicID)
        
        // Bind to phraseViewModel's updates
        phraseViewModel.$phraseCards
            .sink { [weak self] newCards in
                self?.phraseCards = newCards
                self?.updateAlertState(for: topicID)
            }
            .store(in: &cancellables)
        
        phraseViewModel.$errorMessage
            .assign(to: &$errorMessage)
        
        phraseViewModel.$isLoading
            .assign(to: &$isLoading)
        
        phraseViewModel.$cardsAdded
            .assign(to: &$cardsAdded)
    }
    
    private func updateAlertState(for topicID: String) {
        let unreviewedCount = phraseViewModel.countUnreviewedPhrases(for: topicID)
        showUnavailableAlert = unreviewedCount == 0
    }
    
    func resetCardsAdded() {
        cardsAdded = 0
    }
    
    func doneButtonTapped() {
        router.popToRoot()
    }
}
