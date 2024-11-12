import Foundation
import Combine
import SwiftUI

final class StudyPhraseCardViewModel: ObservableObject {
    @Published var phraseCards: [PhraseCardModel] = []
    @Published var selectedCards: [PhraseCardModel] = []
    @Published var selectedCardsIndices: Set<Int> = []
    @Published var showUnavailableAlert = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var cardsAdded: Int = 0
    @Published var cardOffset: CGSize = .zero
    @Published var currIndex: Int = 0
    @Published var currentCard: PhraseCardModel?
    
    private var cancellables = Set<AnyCancellable>()
    private let useCase: PhraseCardUseCaseType
    private let userPhraseUseCase: UserPhraseUseCaseType
    private let firebaseAuthService: FirebaseAuthService
    
    init(useCase: PhraseCardUseCaseType = PhraseCardUseCase(), userPhraseUseCase: UserPhraseUseCaseType = UserPhraseUseCase(), firebaseAuthService: FirebaseAuthService = FirebaseAuthService.shared) {
        self.useCase = useCase
        self.userPhraseUseCase = userPhraseUseCase
        self.firebaseAuthService = firebaseAuthService
    }
    
    func resetCardsAdded() {
        cardsAdded = 0
        selectedCards.removeAll()
        selectedCardsIndices.removeAll()
    }
    
    func checkIfEmpty() {
        if phraseCards.isEmpty {
            showUnavailableAlert = true
        } else {
            showUnavailableAlert = false
        }
        
    }
    
    func fetchPhraseCards(topicID: String) {
        guard !isLoading else { return }
        
        isLoading = true

        useCase.fetchByTopicID(topicID: topicID)
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
                self?.phraseCards = phraseCards?.filter { !$0.isReviewPhase } ?? []
            }
            .store(in: &cancellables)
    }
    
    func updatePhraseCards(phraseID: String, result: PhraseResult){
        useCase.update(id: phraseID, result: result)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] updatedPhraseCard in
                if let index = self?.phraseCards.firstIndex(where: { $0.id == phraseID }) {
                    var currentCard = self?.phraseCards[index]
                    currentCard?.isReviewPhase = true
                    if let updatedCard = currentCard {
                        self?.phraseCards[index] = updatedCard
                        print("Saved phrase to local profile \(updatedCard.phrase)")
                    }
                    
                }
            }
            .store(in: &cancellables)
    }
    
    func savePhraseToRemoteProfile() async {
        do {
            for phrase in selectedCards {
                try await userPhraseUseCase.createPhraseToReview(phrase: UserPhraseCardModel(
                    id: UUID().uuidString,
                    profileID: self.firebaseAuthService.getSessionUser()?.uid ?? "",
                    phraseID: phrase.id,
                    topicID: phrase.topicID,
                    vocabulary: phrase.vocabulary,
                    phrase: phrase.phrase,
                    translation: phrase.translation,
                    prevLevel: "1",
                    nextLevel: "1",
                    nextReviewDate: Date())
                )
                updatePhraseCards(phraseID: phrase.id, result: .undefinedResult)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
//    func updateCurrentCard() {
//        if currIndex <= phraseCards.count  {
//            currentCard = phraseCards[currIndex]
//        } else {
//            currentCard = nil
//        }
//    }
    
    func moveToNextCard(phraseCards: [PhraseCardModel]) {
        guard !phraseCards.isEmpty else { return }

        var newIndex = currIndex + 1
        if newIndex >= phraseCards.count {
            newIndex = 0
        }
        currIndex = newIndex
    }

    func moveToPreviousCard() {
        var newIndex = currIndex - 1
        if newIndex >= 0 {
            currIndex = newIndex
//            updateCurrentCard()
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
    
    func selectCard() {
        selectedCards.insert(phraseCards[currIndex], at: selectedCards.endIndex)
    }
}
