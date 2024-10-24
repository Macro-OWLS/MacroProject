import Foundation
import SwiftUI
import Combine

final class PhraseStudyViewModel: ObservableObject {
    @Published var phraseCardsByLevel: [PhraseCardModel] = []
    @Published var selectedPhraseCardsToReviewByTopic: [PhraseCardModel] = []
    @Published var dueTodayPhraseCards: [PhraseCardModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var currIndex: Int
    @Published var isRevealed: Bool
    @Published var userInput: String
    @Published var recapAnsweredPhraseCards: [UserAnswerDTO]
    @Published var answeredCardIndices: Set<Int> = []
    @Published var isAnswerIndicatorVisible: Bool = false

    private let phraseCardUseCase: PhraseCardUseCase = PhraseCardUseCase()
    private var cancellables = Set<AnyCancellable>()
    
    init(currIndex: Int = 0) {
        self.currIndex = currIndex
        self.isRevealed = false
        self.userInput = ""
        self.recapAnsweredPhraseCards = []
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
    
    func addUserAnswer(userAnswer: UserAnswerDTO) {
        recapAnsweredPhraseCards.append(userAnswer)
        answeredCardIndices.insert(currIndex)
        isAnswerIndicatorVisible = true
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

        var newIndex = currIndex - 1
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
